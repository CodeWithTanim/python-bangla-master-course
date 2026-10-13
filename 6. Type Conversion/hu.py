# ==============================================================
# Project P1: Smart Restaurant Bill & Tip Splitter
# Concepts Practiced: input(), float/int casting, arithmetic, f-strings
# ==============================================================

print("=" * 50)
print("   🍽️  WELCOME TO THE SMART BILL SPLITTER  🍽️")
print("=" * 50)

# 1. Accept user inputs with proper type casting
raw_bill = float(input("Enter the total food bill amount ($): "))
tip_percent = float(input("What percentage tip would you like to give? (e.g. 10, 15, 20): "))
people_count = int(input("How many people are splitting the bill?: "))

# 2. Perform calculations
tip_amount = raw_bill * (tip_percent / 100)
grand_total = raw_bill + tip_amount
share_per_person = grand_total / people_count

# 3. Present formatted summary report
print("\n" + "-" * 40)
print("            BILL BREAKDOWN")
print("-" * 40)
print(f"Original Subtotal:      ${raw_bill:10.2f}")
print(f"Tip ({tip_percent:.0f}%):               ${tip_amount:10.2f}")
print(f"Grand Total:            ${grand_total:10.2f}")
print(f"Number of Diners:        {people_count:10d}")
print("-" * 40)
print(f"👉 Each Person Pays:    ${share_per_person:10.2f}")
print("=" * 50)
print("Thank you for dining with us! Have a wonderful day!")