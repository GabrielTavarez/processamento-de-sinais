### A Pluto.jl notebook ###
# v0.16.3

using Markdown
using InteractiveUtils

# ╔═╡ 2bee4430-66c1-11ed-09bc-89603c1571b0
begin
	using DSP
	using Plots
	using LinearAlgebra
	plotly()
end

# ╔═╡ 7d097b15-7cd1-4772-99e8-b3b4bcaeaf40
md" # EXP 3

* Gabriel Tavares - 10773801
* Guilherme Reis - 10773700
"

# ╔═╡ 9244b40f-93ab-4621-8ced-1eeef691a064
md" ## 1)  Simulação do filtro de 2 coeficientes"

# ╔═╡ 26a19314-47b6-4143-a77a-ffbdcf25c761
md" ### Parâmetros de simulação"

# ╔═╡ 70020f30-238b-4ce2-9ef2-8a105a3d50c1
md" ### Simulação" 

# ╔═╡ f5637c4b-66a3-4ad8-9d24-d82bdac133ee
md" ### Valores teóricos"

# ╔═╡ 92f77e07-626f-408c-bb2c-9e6d793af332
md" ### Comparação de valores simulados e teóricos"

# ╔═╡ 13b008d7-e6f2-4400-949c-e16c65fc4867
md" Como esperado, os valores simulados e  teóricos são bastante próximos. Como o filtro ideal e LMS tem 2 coeficientes, os coeficientes finais tendem para o filtro ideal"

# ╔═╡ 013cc7fe-732f-4ab9-9f78-0d1422667fa3
md" ## 2) Simulação com filtros de 1 e 3 coeficientes"

# ╔═╡ 2109b574-ffa7-4313-92a2-9386026b2dfa
md" ### Simulação 1 coeficiente"

# ╔═╡ d38f420c-5919-48d4-bc36-0f0cd6575b50
md" ### Valores teóricos"

# ╔═╡ d273a310-e7a3-4bd8-977c-11341fa9e356
md" ### Comparação de valores simulados e teóricos"

# ╔═╡ aea388c4-9803-46f8-b2cc-da6350421304
md" ### Simulação 3 coeficientes"

# ╔═╡ f14e8501-1e1c-48fb-aa41-ddef9e6ce319
md" ### Valores teóricos"

# ╔═╡ 9b30788d-a254-4431-881c-6a36cd75b75a
md" ### Comparação de valores simulados e teóricos"

# ╔═╡ a5566b09-0740-460d-bb57-3e95961d22bf
md" Usando um filtro ideal de 2 e 3 coeficientes, vemos que no primeiro caso no o algoritmo converge pra um resultado bom e se mantém na faixa de valores teóricos de EMSE. O primeiro coeficiente do filtro tende ao coeficiente do filtro ideal.

Com 3 coeficientes, o filtro LMS tenta chegar no valor mais próximo possível do filtro real, mas tem uma limitação de projeto de atingir o filtro ideal. Devido a iddo, o seu valor de erro não na convergência fica a cima do valor teórico"

# ╔═╡ 99a2a676-1d50-4aa1-9313-3d1e933cb823
md" # 3) Simulação do filtro adaptativo de 5 coeficientes e o filtro real de 2"

# ╔═╡ 0a44fa58-3a91-4c2b-9b66-6c13e7471661
md" ### Simulação"

# ╔═╡ d1af324e-107a-4fe7-a33f-befd22fcb104
md" ### Valores teóricos"

# ╔═╡ 7e8ae760-49a2-4929-b5b2-fe2f81c4f622
md" ### Comparação de valores simulados e teóricos"

# ╔═╡ a2db55c4-6fdc-4786-bc65-9d3462a1b6bc
md"Nesse exemplo, como esperado o filtro LMS consegue convergir para os valores ideiais e teóricos, por ter coeficientes suficiente para representar o filtro"

# ╔═╡ 35e55f62-c071-4de8-8c45-85bc4c734c18
md" ## 4) Filtrando x[n] antes da adaptação"

# ╔═╡ 6407b218-0fc1-435f-ad60-944789937ed2
md" Aqui estamos usando sinal de entrada x[n] mais complexo do que apenas um ruído gaussiano"

# ╔═╡ a88c5ab4-9577-463b-b392-ae20e5b792fd
md" ### Simulação"

# ╔═╡ 9d15afef-ac16-48f8-b599-633a6343e1e7
md" Nesse exemplo conseguimos ver que os valores simulados ainda tendem para os mesmos valores obtidos anteriormente, mas por ter um sinal mais complexo que um ruído puro, o tempo de convergência é bem maior"

# ╔═╡ 257b4a73-c403-4f82-9c2f-8df8303da062
md" # Functions"

# ╔═╡ 2e016e9f-65b8-43a3-b426-b12fc9076317
function LMS(x, d, M, μ)
	N = length(x)
	X = zeros(M,1)
	W = zeros(N,M)
	erro = zeros(N,1)
	
	for n in 1:N-1
		X = [x[n]; X[1:M-1]]
		y = W[n,:]'*X
		erro[n] = d[n]-y
		W[n+1, :] = W[n,:] +μ*erro[n]*X
	end
	return W, erro
end

# ╔═╡ 6836b7f0-7a88-4f73-898b-1a3e98bb13f1
noprint = md""

# ╔═╡ 6d7a061e-2027-4326-b5a4-cbd9d8517ed6
begin
	N = 200
	realizacoes = 100
	σₓ² = 1
	σᵥ² = 0.01
	noprint
end

# ╔═╡ 90204eff-1b32-4ec4-bbee-962fd0ead60e
begin
	M = 2
	w_lms1 = zeros(N, M)
	erro1 = zeros(N)
	
	h1 = [1, -0.5]
	μ = 0.05
	for realizacao in 1:realizacoes
		x = randn(N)*sqrt(σₓ²)
		v = randn(N)*sqrt(σᵥ²)
		y = filt(h1, x)
		d = y .+ v
		w, erro = LMS(x, d, M, μ)
		w_lms1 += w
		erro1 += erro.*erro
	end
	
	w_lms1 = w_lms1./realizacoes
	erro1 =  erro1./realizacoes
	noprint
end

# ╔═╡ 7c7ee4d4-2d6d-4f8c-966c-88bce6d3bdfe
begin
	Rϕ1 = [σₓ² 0;
		0 σₓ²]
	rdϕ1 = [h1[1]*σₓ², h1[2]*σₓ²]
	K1 = [μ*σᵥ²/2 0;
		0 μ*σᵥ²/2]
	wₒ1 = inv(Rϕ1)*rdϕ1
	
	EMSE = tr(Rϕ1*K1)
	
	noprint
end

# ╔═╡ 4c9cb3c4-858f-4b1f-8b27-99e9f3e3b73a
begin 
	plot(title = "MSE (H -> 2 coefs)")
	plot!(erro1, label= "Valor simulado")
	hline!([(EMSE+σᵥ²)], label = "Valor teórico")
	# plot!(ylim = [0.005, 0.02])
end

# ╔═╡ 6a33894f-8e69-43f5-a664-b865fbddba1f
begin
	plot(title= "Coeficientes (H -> 2 coefs)")
	plot!(w_lms1, label="Simulado")
	hline!([wₒ1[1]], label="Teórico")
	hline!([wₒ1[2]], label="Teórico")
end

# ╔═╡ be563f33-51e2-4937-8c3d-e57b33087429
begin
	# M = 2
	w_lms2 = zeros(N, M)
	erro2 = zeros(N)
	
	h2 = [1]
	# μ = 0.1
	for realizacao in 1:realizacoes
		x = randn(N)*sqrt(σₓ²)
		v = randn(N)*sqrt(σᵥ²)
		y = filt(h2, x)
		d = y .+ v
		w, erro = LMS(x, d, M, μ)
		w_lms2 += w
		erro2 += erro.*erro
	end
	
	w_lms2 = w_lms2./realizacoes
	erro2 =  erro2./realizacoes
	noprint
end

# ╔═╡ 413431d8-efc5-42ba-a4d7-7506f17cfd99
begin
	Rϕ2 = [σₓ² 0;
		0 σₓ²]
	rdϕ2 = [h2[1]*σₓ², 0]
	K2 = [μ*σᵥ²/2 0;
		0 μ*σᵥ²/2]
	wₒ2 = inv(Rϕ2)*rdϕ2
	
	EMSE2 = tr(Rϕ2*K2)
	
	noprint
end

# ╔═╡ a77545b9-cd7e-4048-bb06-840fbe587cce
begin 
	plot(title = "MSE (H -> 2 coefs)")
	plot!(erro2, label= "Valor simulado")
	hline!([(EMSE2+σᵥ²)], label = "Valor teórico")
	# plot!(ylim = [0.005, 0.02])
end

# ╔═╡ e7e892a5-d9c5-43f7-bd7f-25418e9321af
begin
	plot(title= "Coeficientes (H -> 2 coefs)")
	plot!(w_lms2, label="Simulado")
	hline!([wₒ2[1]], label="Teórico")
	hline!([wₒ2[2]], label="Teórico")
end

# ╔═╡ 7b73f8b9-730a-460d-9ad6-677abf9df561
begin
	# M = 2
	w_lms3 = zeros(N, M)
	erro3 = zeros(N)
	
	h3 = [1, -0.5, 0.2]
	# μ = 0.1
	for realizacao in 1:realizacoes
		x = randn(N)*sqrt(σₓ²)
		v = randn(N)*sqrt(σᵥ²)
		y = filt(h3, x)
		d = y .+ v
		w, erro = LMS(x, d, M, μ)
		w_lms3 += w
		erro3 += erro.*erro
	end
	
	w_lms3 = w_lms3./realizacoes
	erro3 =  erro3./realizacoes
	noprint
end

# ╔═╡ 858082b1-3ccb-4cb4-b375-1d926010ae0e
begin
	Rϕ3 = [σₓ² 0;
		0 σₓ²]
	rdϕ3 = [h3[1]*σₓ², h3[2]*σₓ²]
	K3 = [μ*σᵥ²/2 0;
		0 μ*σᵥ²/2]
	wₒ3 = inv(Rϕ2)*rdϕ3
	
	EMSE3 = tr(Rϕ2*K2)
	
	noprint
end

# ╔═╡ d927edd7-2292-496a-a6e0-d3ef5f2ad649
begin 
	plot(title = "MSE (H -> 2 coefs)")
	plot!(erro3, label= "Valor simulado")
	hline!([(EMSE3+σᵥ²)], label = "Valor teórico")
	# plot!(ylim = [0.005, 0.02])
end

# ╔═╡ 6c7eaeb3-ae2c-4904-82db-75dd3bbdd188
begin
	plot(title= "Coeficientes (H -> 2 coefs)")
	plot!(w_lms3, label="Simulado")
	hline!([wₒ3[1]], label="Teórico")
	hline!([wₒ3[2]], label="Teórico")
end

# ╔═╡ b7ca4751-ac6b-45c5-88ed-abad06f4e9e5
begin
	M5 = 5
	w_lms4 = zeros(N, M5)
	erro4 = zeros(N)
	
	h4 = [1, -0.5]
	# μ = 0.1
	for realizacao in 1:realizacoes
		x = randn(N)*sqrt(σₓ²)
		v = randn(N)*sqrt(σᵥ²)
		y = filt(h4, x)
		d = y .+ v
		w, erro = LMS(x, d, M5, μ)
		w_lms4 += w
		erro4 += erro.*erro
	end
	
	w_lms4 = w_lms4./realizacoes
	erro4 =  erro4./realizacoes
	noprint
end

# ╔═╡ 879ca133-529b-43b8-92cf-2198fc5e2a10
begin 
	plot(title = "MSE (H -> 2 coefs)")
	plot!(erro4, label= "Valor simulado")
	hline!([(EMSE2+σᵥ²)], label = "Valor teórico")
	# plot!(ylim = [0.005, 0.02])
end

# ╔═╡ 03588022-e109-4d56-8b88-2fa3a95cc2fe
begin
	plot(title= "Coeficientes (H -> 2 coefs)")
	plot!(w_lms4, label="Simulado")
	hline!([wₒ4[1]], label="Teórico")
	hline!([wₒ4[2]], label="Teórico")
end

# ╔═╡ 2078bdec-5ce6-4df9-b6be-06b55ce46d9f
begin
	Rϕ5 = [σₓ² 0 0 0 0;
		0 σₓ² 0 0 0;
		0 0 σₓ² 0 0;
		0 0 0 σₓ² 0 ;
		0 0 0 0 σₓ²;
	]
	rdϕ5 = [h4[1]*σₓ², h4[2]*σₓ², 0 ,0, 0]
	K5 = [μ*σᵥ²/2 0;
		0 μ*σᵥ²/2]
	wₒ5 = inv(Rϕ5)*rdϕ5
	
	EMSE5 = tr(Rϕ2*K5)
	
	noprint
end

# ╔═╡ b1cfc728-51dc-49ca-afc4-ce4d4263a676
begin
	N2 = 7_000
	w_lms5 = zeros(N2, M)
	w_lms6 = zeros(N2, M)
	w_lms7 = zeros(N2, M)
	erro5 = zeros(N2)
	erro6 = zeros(N2)
	erro7 = zeros(N2)
	
	realizacoes2 = 1_000
	
	σᵤ² = 1
	h5 = [1, -0.5]
	h6 = [1]
	h7 = [1, -0.5, 0.2]
	a = 0.9
	g = PolynomialRatio([sqrt(1-a^2)],[1, -a] )
	μ2 = 0.01
	for realizacao in 1:realizacoes2
		global w_lms5
		global w_lms6
		global w_lms7
		global erro5
		global erro6
		global erro7
		u = randn(N2)*sqrt(σᵤ²)
		x = filt(g, u)
		v = randn(N2)*sqrt(σᵥ²)
		y5 = filt(h5, x)
		y6 = filt(h6, x)
		y7 = filt(h7, x)
		d5 = y5 .+ v
		d6 = y6 .+ v
		d7 = y7 .+ v
		w5, erro5 = LMS(x, d5, M, μ2)
		w6, erro6 = LMS(x, d6, M, μ2)
		w7, erro7 = LMS(x, d7, M, μ2)
		w_lms5 += w5
		w_lms6 += w6
		w_lms7 += w7
		erro5 += erro5.*erro5
		erro6 += erro6.*erro7
		erro7 += erro7.*erro6
	end
	
	w_lms5 = w_lms5./realizacoes2
	w_lms6 = w_lms6./realizacoes2
	w_lms7 = w_lms7./realizacoes2
	erro5 =  erro5./realizacoes2
	erro6 =  erro6./realizacoes2
	erro7 =  erro7./realizacoes2
	noprint
end

# ╔═╡ 5dbe3546-f8d4-4367-a708-be0de313022d
begin 
	plot(title = "MSE (H -> 2 coefs)")
	plot!(erro5, label= "Erro filtro 2 coefs")
	plot!(erro6, label= "Erro filtro 1 coefs")
	plot!(erro7, label= "Erro filtro 3 coefs")
	# hline!([(EMSE2+σᵥ²)], label = "Valor teórico")
	# plot!(ylim = [0.005, 0.02])
end

# ╔═╡ 8550bd06-8da7-4dd7-9887-63a7bad36fce
begin
	plot(title= "Coeficientes (H -> 2 coefs)")
	plot!(w_lms5[:,1], label="Filtro 2 coefs", color = "blue")
	plot!(w_lms5[:,2], label="Filtro 2 coefs", color = "blue")
	plot!(w_lms6[:,1], label="Filtro 1 coefs", color = "red")
	plot!(w_lms6[:,2], label="Filtro 1 coefs", color = "red")
	plot!(w_lms7[:,1], label="Filtro 3 coefs", color = "green")
	plot!(w_lms7[:,2], label="Filtro 3 coefs", color = "green")
	# hline!([wₒ2[1]], label="Teórico")
	# hline!([wₒ2[2]], label="Teórico")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DSP = "717857b8-e6f2-59f4-9121-6e50c889abd2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
DSP = "~0.7.7"
Plots = "~1.36.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BitFlags]]
git-tree-sha1 = "629c6e4a7be8f427d268cebef2a5e3de6c50d462"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.6"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[DSP]]
deps = ["Compat", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "4ba2a190a9d05a36e8c26182eb1ba06cd12c1051"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.7.7"

[[DataAPI]]
git-tree-sha1 = "e08915633fcb3ea83bf9d6126292e5bc5c739922"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.13.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "90630efff0894f8142308e334473eba54c433549"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.5.0"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "00a9d4abadc05b9476e937a5557fcce476b9e547"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.5"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "0c0e8d05fdd5e9792b31b7c7841f11a2ff8ad633"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.5.4"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "df6830e37943c7aaa10023471ca47fb3065cc3c4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.2"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "5955a002262c08ab155ed2a6f1bb0787fedf5939"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.36.2"

[[Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3010a6dd6ad4c7384d2f38c58fa8172797d879c1"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─7d097b15-7cd1-4772-99e8-b3b4bcaeaf40
# ╠═2bee4430-66c1-11ed-09bc-89603c1571b0
# ╟─9244b40f-93ab-4621-8ced-1eeef691a064
# ╟─26a19314-47b6-4143-a77a-ffbdcf25c761
# ╠═6d7a061e-2027-4326-b5a4-cbd9d8517ed6
# ╟─70020f30-238b-4ce2-9ef2-8a105a3d50c1
# ╠═90204eff-1b32-4ec4-bbee-962fd0ead60e
# ╟─f5637c4b-66a3-4ad8-9d24-d82bdac133ee
# ╠═7c7ee4d4-2d6d-4f8c-966c-88bce6d3bdfe
# ╟─92f77e07-626f-408c-bb2c-9e6d793af332
# ╟─4c9cb3c4-858f-4b1f-8b27-99e9f3e3b73a
# ╟─6a33894f-8e69-43f5-a664-b865fbddba1f
# ╟─13b008d7-e6f2-4400-949c-e16c65fc4867
# ╟─013cc7fe-732f-4ab9-9f78-0d1422667fa3
# ╟─2109b574-ffa7-4313-92a2-9386026b2dfa
# ╠═be563f33-51e2-4937-8c3d-e57b33087429
# ╟─d38f420c-5919-48d4-bc36-0f0cd6575b50
# ╠═413431d8-efc5-42ba-a4d7-7506f17cfd99
# ╟─d273a310-e7a3-4bd8-977c-11341fa9e356
# ╟─a77545b9-cd7e-4048-bb06-840fbe587cce
# ╟─e7e892a5-d9c5-43f7-bd7f-25418e9321af
# ╟─aea388c4-9803-46f8-b2cc-da6350421304
# ╠═7b73f8b9-730a-460d-9ad6-677abf9df561
# ╟─f14e8501-1e1c-48fb-aa41-ddef9e6ce319
# ╠═858082b1-3ccb-4cb4-b375-1d926010ae0e
# ╟─9b30788d-a254-4431-881c-6a36cd75b75a
# ╟─d927edd7-2292-496a-a6e0-d3ef5f2ad649
# ╟─6c7eaeb3-ae2c-4904-82db-75dd3bbdd188
# ╟─a5566b09-0740-460d-bb57-3e95961d22bf
# ╟─99a2a676-1d50-4aa1-9313-3d1e933cb823
# ╟─0a44fa58-3a91-4c2b-9b66-6c13e7471661
# ╠═b7ca4751-ac6b-45c5-88ed-abad06f4e9e5
# ╟─d1af324e-107a-4fe7-a33f-befd22fcb104
# ╠═2078bdec-5ce6-4df9-b6be-06b55ce46d9f
# ╟─7e8ae760-49a2-4929-b5b2-fe2f81c4f622
# ╟─879ca133-529b-43b8-92cf-2198fc5e2a10
# ╟─03588022-e109-4d56-8b88-2fa3a95cc2fe
# ╟─a2db55c4-6fdc-4786-bc65-9d3462a1b6bc
# ╟─35e55f62-c071-4de8-8c45-85bc4c734c18
# ╟─6407b218-0fc1-435f-ad60-944789937ed2
# ╟─a88c5ab4-9577-463b-b392-ae20e5b792fd
# ╠═b1cfc728-51dc-49ca-afc4-ce4d4263a676
# ╟─5dbe3546-f8d4-4367-a708-be0de313022d
# ╟─8550bd06-8da7-4dd7-9887-63a7bad36fce
# ╟─9d15afef-ac16-48f8-b599-633a6343e1e7
# ╟─257b4a73-c403-4f82-9c2f-8df8303da062
# ╠═2e016e9f-65b8-43a3-b426-b12fc9076317
# ╠═6836b7f0-7a88-4f73-898b-1a3e98bb13f1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
