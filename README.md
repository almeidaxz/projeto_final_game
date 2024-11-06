# Projeto de game em Godot
## Objetivo
  Este projeto foi desenvolvido para projeto da UC `Usabilidade, desenvolvimento web, mobile e jogos` do curso de Ciência da Computação da Universidade Salvador (ÂNIMA Educação).
  O objetivo do projeto é desenvolver os estágios iniciais de um game com a ferramenta Godot 4, com todos os Assets, Scenes e Scripts. Todas as imagens e ícones foram adquiridos em plataformas de Licença Gratuita, como o [Tech Stack Icons](https://www.tech-stack-icons.com/) e [Freepik](https://www.freepik.com/vectors) e editados com uso do Photoshop.
## Resumo
  O projeto apresenta o level 1 de um jogo da memória que utiliza cartas com ícones de liguagens e ferramentas de tecnologia. Foram utilizados sprites de:
  - CanvasLayout: Contendo janela main do game
  - Node2D: Contendo a imagem de background
    - Sprite2D: Contendo a imagem de background
  - Timer: Realiza contagem para que as cartas sejam viradas para trás, em caso de par divergente
  - Timer2: Realiza contagem para evitar que novos cliques aconteçam enquanto um par de cartas estiver revelado
  - TouchScreenButton: Contem área clicável contendo imagem da carta, que varia entre a imagem do fundo da carta e a imagem da frente dela. [*Este sprite é instanciado multiplicado pela quantidade de cartas em jogo]
