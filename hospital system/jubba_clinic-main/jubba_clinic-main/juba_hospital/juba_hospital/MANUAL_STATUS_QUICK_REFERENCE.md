# 🎯 Manual Transaction Status - Quick Reference Card

## For Doctors

### What You'll See

In the **Assign Medication** page, look for the **Transaction Status** column with a dropdown:

```
┌─────────────────────────────┐
│  ⏳ Pending       ▼        │  <- Yellow dropdown (work in progress)
└─────────────────────────────┘

OR

┌─────────────────────────────┐
│  ✓ Completed     ▼         │  <- Green dropdown (work finished)
└─────────────────────────────┘
```

---

## How to Use

### Mark Patient as Completed

1. **Find the patient** in the table
2. **Click the dropdown** (yellow "Pending")
3. **Select "✓ Completed"**
4. **Dropdown turns green** ✅
5. **Success message appears**

### Change Back to Pending

1. **Click the dropdown** (green "Completed")
2. **Select "⏳ Pending"**
3. **Dropdown turns yellow** 
4. **Status updated**

---

## Status Meanings

| Status | Color | Icon | When to Use |
|--------|-------|------|-------------|
| **Pending** | 🟡 Yellow | ⏳ | Still working on patient |
| **Completed** | 🟢 Green | ✓ | Finished with patient |

---

## Quick Tips

✅ **Status saves automatically** - No need to click "Save"  
✅ **Can change anytime** - Not permanent  
✅ **Persists across logins** - Status remembered  
✅ **One click** - Easy to update  

---

## When to Mark Completed

Mark as **Completed** when:
- ✅ All test results reviewed
- ✅ Treatment plan finalized
- ✅ Patient ready for discharge
- ✅ All work done

Keep as **Pending** when:
- ⏳ Waiting for test results
- ⏳ More work needed
- ⏳ Follow-up required
- ⏳ Still treating

---

## Visual Guide

### Before (Pending):
```
Patient List Table
┌──────────┬─────┬──────────────┬─────────────┐
│ Name     │ Sex │ Lab Status   │ Transaction │
│          │     │              │ Status      │
├──────────┼─────┼──────────────┼─────────────┤
│ Ahmed    │ M   │ pending-lab  │ ⏳ Pending ▼│ <- Yellow
└──────────┴─────┴──────────────┴─────────────┘
```

### After (Completed):
```
Patient List Table
┌──────────┬─────┬──────────────┬─────────────┐
│ Name     │ Sex │ Lab Status   │ Transaction │
│          │     │              │ Status      │
├──────────┼─────┼──────────────┼─────────────┤
│ Ahmed    │ M   │ processed    │ ✓ Completed▼│ <- Green
└──────────┴─────┴──────────────┴─────────────┘
```

---

## Troubleshooting

**Q: Dropdown doesn't change color?**  
A: Refresh the page (F5)

**Q: Status doesn't save?**  
A: Check internet connection, try again

**Q: Can't click dropdown?**  
A: Make sure you're clicking the Transaction Status column

**Q: Error message appears?**  
A: Contact IT support with the error message

---

## Need Help?

- **Documentation**: See MANUAL_TRANSACTION_STATUS_FEATURE.md
- **IT Support**: Contact hospital IT department
- **Training**: Ask your department head

---

**Quick Summary**: Click dropdown → Select status → Done! ✅
