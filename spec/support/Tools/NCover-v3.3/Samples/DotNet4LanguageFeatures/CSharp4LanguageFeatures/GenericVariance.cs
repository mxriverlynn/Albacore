using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSharp4LanguageFeatures
{
    class GenericVariance
    {
        public static Tuple<IEnumerable<Drink>, IEnumerable<Juice>> CreateDrinks()
        {
            var appleFarm = new Farm<Apple>();
            var orangeFarm = new Farm<Orange>();

            
            // This will generate a compiler error in .NET 3.5 and earlier,
            // because an IEnumerable<Apple> cannot be converted to an IEnumerable<Fruit> without a cast
            // the new 'out' keyword in the definition of IEnumerable<T> in .NET 4
            // tells the compiler that the cast is safe because Apple : Fruit,
            // so the compiler does the cast for you (essentially).
            // this is called co-variance. Co-variance means the type parameter expects a base type, but can accept a derived type.
            IEnumerable<Drink> drinks = Factory.MakeAppleJuice(appleFarm.PurchaseProduce(3), new FruitToDrinkConverter<Apple, Drink>(Juice.CreateJuice));

            // This will generate a compiler error in .NET 3.5 and earlier
            // because a Func<Orange, Juice> cannot be converted to a Func<Fruit, Juice>.
            // The new 'in' keyword in the definition of Func<T, TResult> in .NET 4
            // tells the compiler that the 'T' parameter can be any derived type, not just the type specified
            // this is called contra-variance. Contra-variance means the type parameter expects a derived type, but can accept a base type.
            IEnumerable<Juice> moreDrinks = Factory.MakeOrangeJuice(orangeFarm.PurchaseProduce(4), new FruitToDrinkConverter<Orange, Juice>(Juice.CreateJuice));

            return new Tuple<IEnumerable<Drink>, IEnumerable<Juice>>(drinks, moreDrinks);
        }
    }

    class Fruit { }
    class Apple : Fruit { }
    class Orange : Fruit { }

    abstract class Drink
    {
        public abstract int Gallons { get; protected set; }
        public abstract string TypeOfJuice { get; protected set; }
    }
    class Juice : Drink
    {
        public override int Gallons { get; protected set; }
        public override string TypeOfJuice { get; protected set; }

        public static Juice CreateJuice(Fruit item)
        {
            var r = new Random();
            return new Juice()
            {
                Gallons = r.Next(1, 5),
                TypeOfJuice = item.GetType().ToString()
            };
        }
    }

    interface IFarm<out T> { IEnumerable<T> PurchaseProduce(int numToPurchase); }

    class Farm<T> : IFarm<T> where T : Fruit, new()
    {
        public IEnumerable<T> PurchaseProduce(int numToPurchase)
        {
            var list = new List<T>();
            for (int i = 0; i < numToPurchase; i++)
            {
                list.Add(new T());
            }
            return list;
        }
    }

    delegate JJ FruitToDrinkConverter<in FF, out JJ>(FF f);
    static class Factory
    {

        public static IEnumerable<Juice> MakeOrangeJuice(IEnumerable<Orange> produce, FruitToDrinkConverter<Orange, Drink> converter)
        {
            return (from p in produce
                   select converter(p)).Cast<Juice>();
        }

        public static IEnumerable<Juice> MakeAppleJuice(IEnumerable<Apple> produce, FruitToDrinkConverter<Apple, Drink> converter)
        {
            return (from p in produce
                   select converter(p)).Cast<Juice>();
        }
    }

}
