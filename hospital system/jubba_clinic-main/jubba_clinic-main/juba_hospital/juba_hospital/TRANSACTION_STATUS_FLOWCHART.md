# Transaction Status Decision Flowchart

## Visual Decision Tree

```
                    START: Check Patient Status
                              |
                              v
                    ┌─────────────────────┐
                    │ Get Lab Status &    │
                    │ Get X-ray Status    │
                    └─────────┬───────────┘
                              |
                              v
        ┌─────────────────────┴─────────────────────┐
        |                                             |
        v                                             v
┌───────────────────┐                       ┌──────────────────┐
│ Are BOTH Lab AND  │                       │ Is Lab processed │
│ X-ray processed?  │─── YES ──────────────>│ AND X-ray is     │
└───────┬───────────┘                       │ waiting/null?    │
        |                                   └────────┬─────────┘
        NO                                           |
        |                                           YES
        v                                            |
┌───────────────────┐                               |
│ Is X-ray processed│                               |
│ AND Lab is        │─── YES ───────────────────────┤
│ waiting/null?     │                               |
└───────┬───────────┘                               |
        |                                            |
        NO                                           v
        |                                   ┌──────────────────┐
        v                                   │  COMPLETED       │
┌───────────────────┐                      │  🟢 Green Badge  │
│ Are BOTH Lab AND  │                      │  ✓ Checkmark     │
│ X-ray waiting or  │─── YES ──────────>  └──────────────────┘
│ null?             │                              
└───────┬───────────┘                              
        |                                           
        NO                                          
        |                                           
        v                                           
┌───────────────────┐                              
│  IN PROGRESS      │                              
│  🟡 Yellow Badge  │                              
│  ⏳ Hourglass     │                              
└───────────────────┘                              
        ^
        |
        └───── Any other combination
                (pending tests)


        ┌───────────────────┐
        │  NO TESTS ORDERED │
        │  ⚪ Gray Badge    │
        │  🕐 Clock         │
        └───────────────────┘
                ^
                |
                └───── Both waiting/null
```

---

## Status Combinations Table

| Lab Status | X-ray Status | Result | Badge | Reason |
|------------|--------------|--------|-------|--------|
| **processed** | **image_processed** | ✅ Completed | 🟢 Green | Both tests done |
| **lab-processed** | **xray-processed** | ✅ Completed | 🟢 Green | Both tests done |
| **processed** | **waiting** | ✅ Completed | 🟢 Green | Lab done, no xray ordered |
| **processed** | **null** | ✅ Completed | 🟢 Green | Lab done, no xray ordered |
| **waiting** | **image_processed** | ✅ Completed | 🟢 Green | Xray done, no lab ordered |
| **null** | **xray-processed** | ✅ Completed | 🟢 Green | Xray done, no lab ordered |
| **waiting** | **waiting** | 🕐 No Tests | ⚪ Gray | Nothing ordered yet |
| **null** | **null** | 🕐 No Tests | ⚪ Gray | Nothing ordered yet |
| **pending-lab** | **waiting** | ⏳ In Progress | 🟡 Yellow | Lab pending |
| **pending-lab** | **pending_image** | ⏳ In Progress | 🟡 Yellow | Both pending |
| **processed** | **pending_image** | ⏳ In Progress | 🟡 Yellow | Lab done, xray pending |
| **pending-lab** | **image_processed** | ⏳ In Progress | 🟡 Yellow | Xray done, lab pending |

---

## Simplified Logic

```javascript
function getTransactionStatus(labStatus, xrayStatus) {
    
    // CASE 1: Both completed
    if ((labStatus === 'lab-processed' OR 'processed') 
        AND (xrayStatus === 'image_processed' OR 'xray-processed')) {
        return "✅ Completed (Green)";
    }
    
    // CASE 2: Lab completed, no xray
    else if ((labStatus === 'lab-processed' OR 'processed') 
        AND (xrayStatus === 'waiting' OR null)) {
        return "✅ Completed (Green)";
    }
    
    // CASE 3: Xray completed, no lab
    else if ((xrayStatus === 'image_processed' OR 'xray-processed') 
        AND (labStatus === 'waiting' OR null)) {
        return "✅ Completed (Green)";
    }
    
    // CASE 4: Nothing ordered
    else if ((labStatus === 'waiting' OR null) 
        AND (xrayStatus === 'waiting' OR null)) {
        return "🕐 No Tests Ordered (Gray)";
    }
    
    // CASE 5: Everything else (pending tests)
    else {
        return "⏳ In Progress (Yellow)";
    }
}
```

---

## Real-World Examples

### Example 1: Simple Medication Case
```
Patient: Ahmed Ali
Action: Doctor prescribes medication only

Lab Status: waiting
X-ray Status: waiting

Result: 🕐 No Tests Ordered (Gray)
Reason: Only medication, no diagnostic work needed
```

### Example 2: Lab Work Required
```
Patient: Fatima Hassan
Action: Doctor prescribes medication + orders lab test

Initial State:
  Lab Status: pending-lab
  X-ray Status: waiting
  Result: ⏳ In Progress (Yellow)

After Lab Completion:
  Lab Status: lab-processed
  X-ray Status: waiting
  Result: ✅ Completed (Green)
```

### Example 3: Full Diagnostic Workup
```
Patient: Omar Mohamed
Action: Doctor prescribes medication + orders lab + orders x-ray

State 1 - Tests Ordered:
  Lab Status: pending-lab
  X-ray Status: pending_image
  Result: ⏳ In Progress (Yellow)

State 2 - Lab Done:
  Lab Status: lab-processed
  X-ray Status: pending_image
  Result: ⏳ In Progress (Yellow)
  [Still waiting for x-ray]

State 3 - Both Done:
  Lab Status: lab-processed
  X-ray Status: image_processed
  Result: ✅ Completed (Green)
  [Ready for doctor review]
```

### Example 4: X-ray Only
```
Patient: Sara Ibrahim
Action: Doctor prescribes medication + orders x-ray (no lab needed)

Initial State:
  Lab Status: waiting
  X-ray Status: pending_image
  Result: ⏳ In Progress (Yellow)

After X-ray Completion:
  Lab Status: waiting
  X-ray Status: image_processed
  Result: ✅ Completed (Green)
```

---

## Status Progression Timeline

### Typical Patient Journey

```
Time    Action                          Lab Status      X-ray Status    Transaction Status
────────────────────────────────────────────────────────────────────────────────────────────
09:00   Patient arrives                 waiting         waiting         🕐 No Tests
09:15   Doctor assigns medication       waiting         waiting         🕐 No Tests
09:20   Doctor orders lab test          pending-lab     waiting         ⏳ In Progress
10:00   Lab collects sample            pending-lab     waiting         ⏳ In Progress
11:30   Lab completes test             lab-processed   waiting         ✅ Completed
11:35   Doctor reviews results         lab-processed   waiting         ✅ Completed
11:45   Patient discharged             lab-processed   waiting         ✅ Completed
```

### Complex Case with Multiple Tests

```
Time    Action                          Lab Status      X-ray Status    Transaction Status
────────────────────────────────────────────────────────────────────────────────────────────
08:00   Patient arrives                 waiting         waiting         🕐 No Tests
08:15   Doctor assigns medication       waiting         waiting         🕐 No Tests
08:20   Doctor orders lab + x-ray       pending-lab     pending_image   ⏳ In Progress
08:30   Lab collects sample            pending-lab     pending_image   ⏳ In Progress
08:45   X-ray taken                    pending-lab     pending_image   ⏳ In Progress
10:00   X-ray processed                pending-lab     image_processed ⏳ In Progress
11:30   Lab completed                  lab-processed   image_processed ✅ Completed
11:40   Doctor reviews both            lab-processed   image_processed ✅ Completed
12:00   Treatment plan finalized       lab-processed   image_processed ✅ Completed
```

---

## Color Code Psychology

### 🟢 Green (Completed)
- **Meaning**: Success, ready, good to go
- **Action**: Review results and finalize
- **Priority**: High - these patients can be completed
- **Emotion**: Positive, accomplished

### 🟡 Yellow (In Progress)
- **Meaning**: Caution, waiting, ongoing
- **Action**: Monitor, check back later
- **Priority**: Medium - needs time to complete
- **Emotion**: Neutral, patient

### ⚪ Gray (No Tests)
- **Meaning**: Neutral, simple case
- **Action**: Can complete immediately
- **Priority**: Quick win
- **Emotion**: Simple, straightforward

---

## Testing Matrix

### Test Scenarios to Verify

| Test # | Lab | X-ray | Expected | Pass/Fail |
|--------|-----|-------|----------|-----------|
| 1 | waiting | waiting | Gray | [ ] |
| 2 | processed | waiting | Green | [ ] |
| 3 | waiting | image_processed | Green | [ ] |
| 4 | processed | image_processed | Green | [ ] |
| 5 | pending-lab | waiting | Yellow | [ ] |
| 6 | waiting | pending_image | Yellow | [ ] |
| 7 | pending-lab | pending_image | Yellow | [ ] |
| 8 | processed | pending_image | Yellow | [ ] |
| 9 | pending-lab | image_processed | Yellow | [ ] |
| 10 | null | null | Gray | [ ] |

---

## Integration Points

### Where Status Values Come From

```
Database → Backend C# → JSON Response → JavaScript → HTML Display

patient table               assignmed.aspx.cs        assignmed.aspx
prescribtion table    →     medic() WebMethod   →    getTransactionStatus()
lab_orders table            returns ptclass[]        returns HTML badge
xray table
```

### Status Field Mapping

```
Database Field              Backend Property        Frontend Variable
──────────────────────────────────────────────────────────────────────
prescribtion.status    →    field.status       →    response.d[i].status
prescribtion.xray_status →  field.xray_status  →    response.d[i].xray_status
```

---

## Troubleshooting Decision Tree

```
Problem: Status not showing correctly
    |
    ├─> Is page loaded? 
    │   └─> No: Refresh page
    │
    ├─> Is JavaScript error in console?
    │   └─> Yes: Check browser console, fix error
    │
    ├─> Are status values correct in database?
    │   └─> No: Update lab/xray status in database
    │
    └─> Is badge displaying at all?
        ├─> No: Check CSS is loaded
        └─> Yes but wrong: Check getTransactionStatus() logic
```

---

**This flowchart helps understand the decision logic for displaying transaction status badges in the Assign Medication page.**
