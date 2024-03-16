shader_type canvas_item;
//render_mode unshaded;

uniform sampler2D screen : hint_screen_texture, repeat_enable, filter_nearest_mipmap;
// Входные параметры
uniform vec2 center;  // Координаты центра лупы
uniform float radius; // Радиус лупы
uniform float zoom;   // Уровень увеличения

// Выходной цвет
void fragment() {
  // Координаты пикселя в нормированном пространстве текстуры (от 0.0 до 1.0)
  vec2 uv = UV;
  
  // Расстояние от пикселя до центра лупы
  vec2 dist = uv - center;
  
  // Проверка нахождения пикселя внутри лупы
  if (length(dist) > radius) {
    discard; // Отбрасываем пиксель, если он находится за пределами лупы
  }
  
  // Преобразование координат пикселя в пространство лупы
  vec2 zoomed_uv = (dist / radius) * zoom + center;
  

  // Сэмплирование текстуры с использованием увеличенных координат
  vec4 color = texture(screen, zoomed_uv);
  
  // Вывод цвета
  COLOR = color;
}

