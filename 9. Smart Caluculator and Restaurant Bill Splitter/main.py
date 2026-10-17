# ==========================================================
# Project Name: Smart Calculator & Restaurant Bill Splitter
# Date: October 2026
# ==========================================================

# Header
print("=" * 52)
print("               RESTAURANT BILL")
print("                 CALCULATOR")
print("=" * 52)

# User input
bill = float(input('Enter Your Bill $ '))
tip = float(input('Enter YOur Tip Percentage: (e.g. 10%, 15%, 20%): '))
people = float(input('Enter how many people are splitting the bill: '))

# Calculation
tip_amount = bill * (tip / 100)
total_bill = bill + tip_amount
people_share = total_bill / people

# BILL SUMMARY OUTPUT
print('-' * 52)
print('                  SUMMARY')
print('-' * 52)
print(f"Bill Amount: $ {bill:.2f}")
print(f"Tip Percentage {tip:.0f}%")
print(f"Tip Amount $ {tip_amount:.2f}")
print(f"Total Bill $ {total_bill:.2f}")
print(f"Total People Slitting: {people}")
print('-' * 52)
print(f"Each Person Have to Pay: $ {people_share}")
print('-' * 52)