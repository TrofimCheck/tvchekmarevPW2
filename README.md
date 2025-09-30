# WishMaker Project

iOS-приложение на UIKit. Пользователь может менять цвет фона экрана с помощью трёх слайдеров (Red, Green, Blue) и управлять их отображением кнопкой.

## Questions and Answers

**Q: What issues prevent us from using storyboards in real projects?**  
A: Сториборды сложно мержить в Git, они плохо масштабируются для больших команд и усложняют переиспользование кода интерфейса.  

**Q: What does the code on lines 25 and 29 do?**  
A: Строка 25 отключает автоматическую конвертацию autoresizing mask в констрейнты.  
Строка 29 добавляет лейбл в иерархию вью контроллера (`view.addSubview`).  

**Q: What is a safe area layout guide?**  
A: Это область экрана, не перекрытая системными элементами (например, «чёлкой», индикатором домой, статус-баром).  

**Q: What is [weak self] on line 23 and why it is important?**  
A: `[weak self]` делает ссылку на контроллер слабой внутри замыкания. Это предотвращает утечки памяти и retain cycle.  

**Q: What does clipsToBounds mean?**  
A: Если включено, то содержимое под-вью, выходящее за границы вью, обрезается и не отображается.  

**Q: What is the valueChanged type? What is Void and what is Double?**  
A: `valueChanged` — это замыкание с типом `(Double) -> Void`.  
`Double` — число с плавающей точкой (значение слайдера).  
`Void` — означает, что функция/замыкание ничего не возвращает.  
