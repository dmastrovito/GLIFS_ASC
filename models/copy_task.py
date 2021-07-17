import matplotlib
matplotlib.use('Agg')

# author: @chloewin
# 03/07/21
import pickle
import datetime
import utils as ut
from networks import RBNN, RNNFC, BNNFC, LSTMFC
from neurons.glif_new import BNNC, RNNC, Placeholder

import matplotlib.pyplot as plt
import numpy as np

import torch
import torch.optim as optim
import torch.utils.data as tud
import torch.nn as nn
import math
# import torch.utils.data.DataLoader

# torch.autograd.set_detect_anomaly(True)
"""
This file trains a network of rate-based GLIF neurons with after-spike currents on a pattern generation task.
1. Single pattern generation: generate a sinusoid of a given frequency when provided with constant input
2. Sussillo pattern generation: generate a sinusoid of a freuqency that is proportional to the amplitude of the constant input
3. Bellec pattern generation: generation a sinusoid of a frequency that corresponds to the subset of input neurons receiving input

Trained model is saved to the folder specified by model_name + date.
Figures on learned outputs, parameters, weights, gradients, and losses over training are saved to the folder specified by fig_name + date

Loss is printed on every epoch

To alter model architecture, change sizes, layers, and conns dictionaries. 
There are other specifications including amount of time, number of epochs, learning rate, etc.
"""

def main():
	main_name = "copy_tryagn_1ms_128uits"#"3dsine_rnn_long"#"brnn200_noncued_moreascs_diffinit"#"brnn200_sussillo8_batched_hisgmav_predrive_scaleasc_wtonly_agn_nodivstart"#lng_lngersim_uniformoffset_furthertrain"
	on_server = False

	if on_server:
		base_name = main_name
		base_name_save = main_name
		base_name_model = main_name
	else:
		base_name = "figures_wkof_060621/" + main_name
		base_name_save = "traininfo_wkof_060621/" + main_name
		base_name_model = "models_wkof_060621/" + main_name

	use_rnn = False

	hid_size = 128#64
	input_size = 10
	output_size = 10

	# Generate data
	sim_time = 1
	dt = 0.05
	amp = 1
	noise_mean = 0
	noise_std = 0

	batch_size = 1
	num_patterns = 1

	inputs, targets = ut.create_copy(sim_time, dt, noise_mean, noise_std, n=num_patterns)
	traindataset = ut.create_dataset(inputs, targets, input_size, output_size, task = "copy")

	def data_gen(n=num_patterns):
		inputs, targets = ut.create_copy(sim_time, dt, noise_mean, noise_std, n=n)
		return ut.create_dataset(inputs, targets, input_size, output_size, task = "copy")

	# # traindataset = ut.ThreeBitDataset(int(sim_time / dt), dataset_length=128)

	# # Generate model
	# delay = int(0.5 / dt)
	if use_rnn:
		model = LSTMFC(in_size = input_size, hid_size = hid_size, out_size = output_size)
	else:
		model = BNNFC(in_size = input_size, hid_size = hid_size, out_size = output_size)
	# model.load_state_dict(torch.load("saved_models/3dsine_rnn.pt"))#"saved_models/models_wkof_051621/brnn200_sussillo8_batched_hisgmav_predrive_scaleasc_wtonly_agn_nodivstart.pt"))
	# Train model
	num_epochs = 500
	lr = 0.0025#0.005
	reg_lambda = 0#0.001
	torch.save(model.state_dict(), "saved_models/" + base_name_model + "_init.pt")

	# num_epochss = [200,100,50,10,1,1]
	# for p in model.parameters():
	#       p.register_hook(lambda grad: torch.clamp(grad, -0.5, 0.5))
	training_info = ut.train_rbnn(model, traindataset, batch_size, num_epochs, lr, reg_lambda, data_gen = data_gen, glifr = not use_rnn, task = "copy", decay=False)

	torch.save(model.state_dict(), "saved_models/" + base_name_model + ".pt")

	colors = ["sienna", "peru", "peachpuff", "salmon", "red", "darkorange", "purple", "fuchsia", "plum", "darkorchid", "slateblue", "mediumblue", "cornflowerblue", "skyblue", "aqua", "aquamarine", "springgreen", "green", "lightgreen"]

	# Plot losses
	plt.plot(training_info["losses"])
	plt.xlabel("epoch #")
	plt.ylabel("loss")
	plt.savefig("figures/" + base_name + "_losses")
	plt.close()
	torch.save(training_info["losses"], "traininfo/" + base_name_save + "_losses.pt")

	colors = ["sienna", "gold", "chartreuse", "darkgreen", "lightseagreen", "deepskyblue", "blue", "darkorchid", "plum", "darkorange", "fuchsia", "tomato", "cyan", "greenyellow", "cornflowerblue", "limegreen", "springgreen", "green", "lightgreen", "aquamarine", "springgreen", "green", "lightgreen", "aquamarine", "springgreen", "green", "lightgreen", "aquamarine", "springgreen", "green", "lightgreen", "aquamarine", "springgreen", "green", "lightgreen"]

	if not use_rnn:
		i = -1
		for name in ["threshes", "k_ms", "asc_amps", "asc_rs", "asc_ks"]:
			print(name)
			i += 1
			_, l = np.array(training_info[name]).shape
			for j in range(l):
				plt.plot(np.array(training_info[name])[:, j], color = colors[i], alpha = 0.5, label = name if j == 0 else "")
		plt.legend()
		plt.xlabel('epoch')
		plt.ylabel('parameter')
		plt.savefig("figures/" + base_name + "_parameters")
		plt.close()
	with open("traininfo/" + base_name_save + ".pickle", 'wb') as handle:
		pickle.dump(training_info, handle)

if __name__ == '__main__':
	main()