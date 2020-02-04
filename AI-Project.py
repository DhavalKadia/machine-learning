# Dhaval Kadia, 101622808
# Traffic-Sign Recognition

import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

def binary(path):
    image = mpimg.imread(path)
    t = tf.cast(image, tf.float32)
    t = tf.reshape(t, [400, -1, 4])
    t = t[:, 0]
    t = t[:, 0]
    t = tf.reshape(t, [20, 20, 1])
    t = tf.div(t, 255.0)
    return t

def binary_transpose(path):
    image = mpimg.imread(path)
    t = tf.cast(image, tf.float32)
    t = tf.reshape(t, [400, -1, 4])
    t = t[:, 0]
    t = t[:, 0]    
    t = tf.div(t, 255.0)

    t = tf.reshape(t, [20, 20])
    t = tf.transpose(t)
    t = tf.reshape(t, [20, 20, 1])    
    
    return t

def NN(mat):
    y1 = tf.nn.relu(tf.nn.conv2d(mat, w1, strides = [1, 1, 1, 1], padding = 'SAME') + b1)
    y2 = tf.nn.relu(tf.nn.conv2d(y1,  w2, strides = [1, 2, 2, 1], padding = 'SAME') + b2)
    y3 = tf.nn.relu(tf.nn.conv2d(y2,  w3, strides = [1, 2, 2, 1], padding = 'SAME') + b3)
    
    yy = tf.reshape(y3, shape = [-1, 5 * 5 * 10])
    
    y4 = tf.nn.relu(tf.matmul(yy, w4) + b4)
    y_ = tf.nn.softmax(tf.matmul(y4, w5) + b5)

    return y_    

image_n = 360

t_ = tf.placeholder(tf.float32, shape = [image_n,4], name = "t-input")
x_ = tf.placeholder(tf.float32, shape = [image_n,20,20,1], name = "x-input")

w1 = tf.Variable(tf.truncated_normal([2, 2,  1,  6], stddev = 0.1))
b1 = tf.Variable(tf.ones([6])/10)

w2 = tf.Variable(tf.truncated_normal([4, 4,  6, 16], stddev = 0.1))
b2 = tf.Variable(tf.ones([16])/10)

w3 = tf.Variable(tf.truncated_normal([5, 5, 16, 10], stddev = 0.1))
b3 = tf.Variable(tf.ones([10])/10)

w4 = tf.Variable(tf.truncated_normal([5*5*10, 400], stddev = 0.1))
b4 = tf.Variable(tf.ones([400])/10)

w5 = tf.Variable(tf.truncated_normal([400, 4], stddev = 0.1))
b5 = tf.Variable(tf.ones([4])/10)

y_ = NN(x_)

cost = tf.reduce_mean(tf.square(y_ - t_))

learning_rate = 0.01

train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(cost)

init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)

ext = ".bmp"
left_train = "C:/Users/dhaval/Desktop/img/l/a"
right_train = "C:/Users/dhaval/Desktop/img/r/a"

x_val = []
x_val = tf.reshape(x_val, [-1, 20, 20, 1])
t_value = []
t_value = tf.reshape(t_value, [-1, 4])

t = tf.eye(4)

for n in range(1, 11):
    img_bin = binary(left_train + str(n) + ext)
    x_val = tf.concat([x_val, [img_bin]], 0)
    t_value = tf.concat([t_value,  tf.gather_nd(t, [[0]])], 0)

    img_bin = binary_transpose(left_train + str(n) + ext)
    x_val = tf.concat([x_val, [img_bin]], 0)
    t_value = tf.concat([t_value,  tf.gather_nd(t, [[2]])], 0)

for n in range(1, 11):
    img_bin = binary(right_train + str(n) + ext)
    x_val = tf.concat([x_val, [img_bin]], 0)
    t_value = tf.concat([t_value,  tf.gather_nd(t, [[1]])], 0)
    
    img_bin = binary_transpose(right_train + str(n) + ext)
    x_val = tf.concat([x_val, [img_bin]], 0)
    t_value = tf.concat([t_value,  tf.gather_nd(t, [[3]])], 0)

sh = 1

x_val_d = tf.roll(x_val, shift=[sh, 0], axis=[1, 2])
x_val_u = tf.roll(x_val, shift=[-sh, 0], axis=[1, 2])
x_val_r = tf.roll(x_val, shift=[0, sh], axis=[1, 2])
x_val_l = tf.roll(x_val, shift=[0, -sh], axis=[1, 2])

x_val_dr = tf.roll(x_val, shift=[sh, sh], axis=[1, 2])
x_val_dl = tf.roll(x_val, shift=[sh, -sh], axis=[1, 2])
x_val_ur = tf.roll(x_val, shift=[-sh, sh], axis=[1, 2])
x_val_ul = tf.roll(x_val, shift=[-sh, -sh], axis=[1, 2])

x_val = tf.concat([x_val, x_val_d], 0)
x_val = tf.concat([x_val, x_val_u], 0)
x_val = tf.concat([x_val, x_val_r], 0)
x_val = tf.concat([x_val, x_val_l], 0)

x_val = tf.concat([x_val, x_val_dr], 0)
x_val = tf.concat([x_val, x_val_dl], 0)
x_val = tf.concat([x_val, x_val_ur], 0)
x_val = tf.concat([x_val, x_val_ul], 0)

t_value_org = t_value
for x in range(0, 8):
    t_value = tf.concat([t_value, t_value_org], 0)

x_val = tf.cast(x_val, tf.float32)
x_value = x_val.eval(session=sess)

t_value = tf.cast(t_value, tf.float32)
t_value = t_value.eval(session=sess)

left_test = "C:/Users/dhaval/Desktop/img/l/t"
right_test = "C:/Users/dhaval/Desktop/img/r/t"
up_test = "C:/Users/dhaval/Desktop/img/u/t"
down_test = "C:/Users/dhaval/Desktop/img/d/t"

test_images = []
test_images = tf.reshape(test_images, [-1, 20, 20, 1])

for n in range(1, 7):
    img_bin = binary(left_test + str(n) + ext)
    test_images = tf.concat([test_images, [img_bin]], 0)

for n in range(1, 7):
    img_bin = binary(right_test + str(n) + ext)
    test_images = tf.concat([test_images, [img_bin]], 0)

for n in range(1, 7):
    img_bin = binary(up_test + str(n) + ext)
    test_images = tf.concat([test_images, [img_bin]], 0)

for n in range(1, 7):
    img_bin = binary(down_test + str(n) + ext)
    test_images = tf.concat([test_images, [img_bin]], 0)

for i in range(1000000):
    sess.run(train_step, feed_dict={x_: x_value, t_: t_value})
    if i % 100 == 0:
        print('Epoch ', i)
        sess.run(y_, feed_dict={x_: x_value, t_: t_value})
        
        sess.run(w1)
        sess.run(b1)
        sess.run(w2)
        sess.run(b2)
        sess.run(w3)
        sess.run(b3)
        sess.run(w4)
        sess.run(b4)
        sess.run(w5)
        sess.run(b5)
        
        sess.run(cost, feed_dict={x_: x_value, t_: t_value})

        learning_rate = learning_rate / 1.2

        for n in range(0, 24):           # CAUTION !!! Index starts from 0 for gather_nd
            test_img = tf.gather_nd(test_images, [[n]])

            y_ = NN(test_img)

            if n % 6 == 0:
                print('')
            
            print('Image ',n + 1,' : ', sess.run(y_))
