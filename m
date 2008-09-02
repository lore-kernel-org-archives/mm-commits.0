From: akpm@linux-foundation.org
Subject: - drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:47 -0700
Message-ID: <200809022041.m82KflqS011661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYIBUl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cordesam@gmail.com, cordsam@linux.vnet.ibm.com, jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#25: FILE: drivers/pci/hotplug/ibmphp_ebda.c:127:
+	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {

WARNING: space prohibited between function name and open parenthesis '('
#37: FILE: drivers/pci/hotplug/ibmphp_ebda.c:148:
+	list_for_each_entry (ptr, &rio_lo_head, rio_detail_list) {

WARNING: space prohibited between function name and open parenthesis '('
#49: FILE: drivers/pci/hotplug/ibmphp_ebda.c:163:
+	list_for_each_entry (ptr, &rio_vg_head, rio_detail_list) {

WARNING: line over 80 characters
#61: FILE: drivers/pci/hotplug/ibmphp_ebda.c:178:
+	list_for_each_entry (ptr, &ibmphp_ebda_pci_rsrc_head, ebda_pci_rsrc_list) {

WARNING: space prohibited between function name and open parenthesis '('
#61: FILE: drivers/pci/hotplug/ibmphp_ebda.c:178:
+	list_for_each_entry (ptr, &ibmphp_ebda_pci_rsrc_head, ebda_pci_rsrc_list) {

WARNING: space prohibited between function name and open parenthesis '('
#73: FILE: drivers/pci/hotplug/ibmphp_ebda.c:188:
+	list_for_each_entry (ptr, &ibmphp_slot_head, ibm_slot_list) {

WARNING: space prohibited between function name and open parenthesis '('
#85: FILE: drivers/pci/hotplug/ibmphp_ebda.c:197:
+	list_for_each_entry (ptr, &opt_vg_head, opt_rio_list) {

WARNING: space prohibited between function name and open parenthesis '('
#100: FILE: drivers/pci/hotplug/ibmphp_ebda.c:210:
+	list_for_each_entry (hpc_ptr, &ebda_hpc_head, ebda_hpc_list) {

WARNING: space prohibited between function name and open parenthesis '('
#111: FILE: drivers/pci/hotplug/ibmphp_ebda.c:447:
+	list_for_each_entry (ptr, &opt_vg_head, opt_rio_list) {

WARNING: space prohibited between function name and open parenthesis '('
#123: FILE: drivers/pci/hotplug/ibmphp_ebda.c:459:
+	list_for_each_entry (rio_detail_ptr, &rio_vg_head, rio_detail_list) {

WARNING: space prohibited between function name and open parenthesis '('
#140: FILE: drivers/pci/hotplug/ibmphp_ebda.c:485:
+	list_for_each_entry (ptr, &opt_lo_head, opt_rio_lo_list) {

WARNING: space prohibited between function name and open parenthesis '('
#152: FILE: drivers/pci/hotplug/ibmphp_ebda.c:497:
+	list_for_each_entry (rio_detail_ptr, &rio_lo_head, rio_detail_list) {

WARNING: space prohibited between function name and open parenthesis '('
#166: FILE: drivers/pci/hotplug/ibmphp_ebda.c:532:
+		list_for_each_entry (opt_vg_ptr, &opt_vg_head, opt_rio_list) {

WARNING: line over 80 characters
#175: FILE: drivers/pci/hotplug/ibmphp_ebda.c:539:
+		list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {

WARNING: space prohibited between function name and open parenthesis '('
#175: FILE: drivers/pci/hotplug/ibmphp_ebda.c:539:
+		list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {

WARNING: space prohibited between function name and open parenthesis '('
#187: FILE: drivers/pci/hotplug/ibmphp_ebda.c:553:
+	list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {

WARNING: space prohibited between function name and open parenthesis '('
#199: FILE: drivers/pci/hotplug/ibmphp_ebda.c:565:
+	list_for_each_entry (opt_vg_ptr, &opt_vg_head, opt_rio_list) {

WARNING: space prohibited between function name and open parenthesis '('
#212: FILE: drivers/pci/hotplug/ibmphp_ebda.c:581:
+	list_for_each_entry (slot_cur, &ibmphp_slot_head, ibm_slot_list) {

WARNING: space prohibited between function name and open parenthesis '('
#231: FILE: drivers/pci/hotplug/ibmphp_ebda.c:966:
+	list_for_each_entry (tmp_slot, &ibmphp_slot_head, ibm_slot_list) {

WARNING: space prohibited between function name and open parenthesis '('
#243: FILE: drivers/pci/hotplug/ibmphp_ebda.c:1069:
+	list_for_each_entry (slot, &ibmphp_slot_head, ibm_slot_list) {

WARNING: space prohibited between function name and open parenthesis '('
#255: FILE: drivers/pci/hotplug/ibmphp_ebda.c:1086:
+	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {

WARNING: space prohibited between function name and open parenthesis '('
#267: FILE: drivers/pci/hotplug/ibmphp_ebda.c:1100:
+	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {

WARNING: space prohibited between function name and open parenthesis '('
#280: FILE: drivers/pci/hotplug/ibmphp_ebda.c:1175:
+	list_for_each_entry (ctrl, &ebda_hpc_head, ebda_hpc_list) {

WARNING: space prohibited between function name and open parenthesis '('
#294: FILE: drivers/pci/hotplug/ibmphp_ebda.c:1189:
+	list_for_each_entry (ctrl, &ebda_hpc_head, ebda_hpc_list) {

total: 0 errors, 24 warnings, 259 lines checked

./patches/drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Cordelia Sam <cordesam@gmail.com>
Cc: Cordelia Sam <cordsam@linux.vnet.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_ebda.c |   44 ++++++++++++++--------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN drivers/pci/hotplug/ibmphp_ebda.c~drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes drivers/pci/hotplug/ibmphp_ebda.c
--- a/drivers/pci/hotplug/ibmphp_ebda.c~drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -124,7 +124,7 @@ static void __init print_bus_info (void)
 {
 	struct bus_info *ptr;
 	
-	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {
+	list_for_each_entry(ptr, &bus_info_head, bus_info_list) {
 		debug ("%s - slot_min = %x\n", __func__, ptr->slot_min);
 		debug ("%s - slot_max = %x\n", __func__, ptr->slot_max);
 		debug ("%s - slot_count = %x\n", __func__, ptr->slot_count);
@@ -145,7 +145,7 @@ static void print_lo_info (void)
 {
 	struct rio_detail *ptr;
 	debug ("print_lo_info ----\n");	
-	list_for_each_entry (ptr, &rio_lo_head, rio_detail_list) {
+	list_for_each_entry(ptr, &rio_lo_head, rio_detail_list) {
 		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
 		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
 		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
@@ -160,7 +160,7 @@ static void print_vg_info (void)
 {
 	struct rio_detail *ptr;
 	debug ("%s ---\n", __func__);
-	list_for_each_entry (ptr, &rio_vg_head, rio_detail_list) {
+	list_for_each_entry(ptr, &rio_vg_head, rio_detail_list) {
 		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
 		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
 		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
@@ -175,7 +175,7 @@ static void __init print_ebda_pci_rsrc (
 {
 	struct ebda_pci_rsrc *ptr;
 
-	list_for_each_entry (ptr, &ibmphp_ebda_pci_rsrc_head, ebda_pci_rsrc_list) {
+	list_for_each_entry(ptr, &ibmphp_ebda_pci_rsrc_head, ebda_pci_rsrc_list) {
 		debug ("%s - rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n", 
 			__func__, ptr->rsrc_type ,ptr->bus_num, ptr->dev_fun,ptr->start_addr, ptr->end_addr);
 	}
@@ -185,7 +185,7 @@ static void __init print_ibm_slot (void)
 {
 	struct slot *ptr;
 
-	list_for_each_entry (ptr, &ibmphp_slot_head, ibm_slot_list) {
+	list_for_each_entry(ptr, &ibmphp_slot_head, ibm_slot_list) {
 		debug ("%s - slot_number: %x\n", __func__, ptr->number);
 	}
 }
@@ -194,7 +194,7 @@ static void __init print_opt_vg (void)
 {
 	struct opt_rio *ptr;
 	debug ("%s ---\n", __func__);
-	list_for_each_entry (ptr, &opt_vg_head, opt_rio_list) {
+	list_for_each_entry(ptr, &opt_vg_head, opt_rio_list) {
 		debug ("%s - rio_type %x\n", __func__, ptr->rio_type);
 		debug ("%s - chassis_num: %x\n", __func__, ptr->chassis_num);
 		debug ("%s - first_slot_num: %x\n", __func__, ptr->first_slot_num);
@@ -207,7 +207,7 @@ static void __init print_ebda_hpc (void)
 	struct controller *hpc_ptr;
 	u16 index;
 
-	list_for_each_entry (hpc_ptr, &ebda_hpc_head, ebda_hpc_list) {
+	list_for_each_entry(hpc_ptr, &ebda_hpc_head, ebda_hpc_list) {
 		for (index = 0; index < hpc_ptr->slot_count; index++) {
 			debug ("%s - physical slot#: %x\n", __func__, hpc_ptr->slots[index].slot_num);
 			debug ("%s - pci bus# of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_bus_num);
@@ -444,7 +444,7 @@ static int __init ebda_rio_table (void)
 static struct opt_rio *search_opt_vg (u8 chassis_num)
 {
 	struct opt_rio *ptr;
-	list_for_each_entry (ptr, &opt_vg_head, opt_rio_list) {
+	list_for_each_entry(ptr, &opt_vg_head, opt_rio_list) {
 		if (ptr->chassis_num == chassis_num)
 			return ptr;
 	}		
@@ -456,7 +456,7 @@ static int __init combine_wpg_for_chassi
 	struct opt_rio *opt_rio_ptr = NULL;
 	struct rio_detail *rio_detail_ptr = NULL;
 	
-	list_for_each_entry (rio_detail_ptr, &rio_vg_head, rio_detail_list) {
+	list_for_each_entry(rio_detail_ptr, &rio_vg_head, rio_detail_list) {
 		opt_rio_ptr = search_opt_vg (rio_detail_ptr->chassis_num);
 		if (!opt_rio_ptr) {
 			opt_rio_ptr = kzalloc(sizeof(struct opt_rio), GFP_KERNEL);
@@ -482,7 +482,7 @@ static int __init combine_wpg_for_chassi
 static struct opt_rio_lo *search_opt_lo (u8 chassis_num)
 {
 	struct opt_rio_lo *ptr;
-	list_for_each_entry (ptr, &opt_lo_head, opt_rio_lo_list) {
+	list_for_each_entry(ptr, &opt_lo_head, opt_rio_lo_list) {
 		if (ptr->chassis_num == chassis_num)
 			return ptr;
 	}		
@@ -494,7 +494,7 @@ static int combine_wpg_for_expansion (vo
 	struct opt_rio_lo *opt_rio_lo_ptr = NULL;
 	struct rio_detail *rio_detail_ptr = NULL;
 	
-	list_for_each_entry (rio_detail_ptr, &rio_lo_head, rio_detail_list) {
+	list_for_each_entry(rio_detail_ptr, &rio_lo_head, rio_detail_list) {
 		opt_rio_lo_ptr = search_opt_lo (rio_detail_ptr->chassis_num);
 		if (!opt_rio_lo_ptr) {
 			opt_rio_lo_ptr = kzalloc(sizeof(struct opt_rio_lo), GFP_KERNEL);
@@ -529,14 +529,14 @@ static int first_slot_num (u8 slot_num, 
 	int rc = 0;
 
 	if (!var) {
-		list_for_each_entry (opt_vg_ptr, &opt_vg_head, opt_rio_list) {
+		list_for_each_entry(opt_vg_ptr, &opt_vg_head, opt_rio_list) {
 			if ((first_slot < opt_vg_ptr->first_slot_num) && (slot_num >= opt_vg_ptr->first_slot_num)) { 
 				rc = -ENODEV;
 				break;
 			}
 		}
 	} else {
-		list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {
+		list_for_each_entry(opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {
 			if ((first_slot < opt_lo_ptr->first_slot_num) && (slot_num >= opt_lo_ptr->first_slot_num)) {
 				rc = -ENODEV;
 				break;
@@ -550,7 +550,7 @@ static struct opt_rio_lo * find_rxe_num 
 {
 	struct opt_rio_lo *opt_lo_ptr;
 
-	list_for_each_entry (opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {
+	list_for_each_entry(opt_lo_ptr, &opt_lo_head, opt_rio_lo_list) {
 		//check to see if this slot_num belongs to expansion box
 		if ((slot_num >= opt_lo_ptr->first_slot_num) && (!first_slot_num (slot_num, opt_lo_ptr->first_slot_num, 1))) 
 			return opt_lo_ptr;
@@ -562,7 +562,7 @@ static struct opt_rio * find_chassis_num
 {
 	struct opt_rio *opt_vg_ptr;
 
-	list_for_each_entry (opt_vg_ptr, &opt_vg_head, opt_rio_list) {
+	list_for_each_entry(opt_vg_ptr, &opt_vg_head, opt_rio_list) {
 		//check to see if this slot_num belongs to chassis 
 		if ((slot_num >= opt_vg_ptr->first_slot_num) && (!first_slot_num (slot_num, opt_vg_ptr->first_slot_num, 0))) 
 			return opt_vg_ptr;
@@ -578,7 +578,7 @@ static u8 calculate_first_slot (u8 slot_
 	u8 first_slot = 1;
 	struct slot * slot_cur;
 	
-	list_for_each_entry (slot_cur, &ibmphp_slot_head, ibm_slot_list) {
+	list_for_each_entry(slot_cur, &ibmphp_slot_head, ibm_slot_list) {
 		if (slot_cur->ctrl) {
 			if ((slot_cur->ctrl->ctlr_type != 4) && (slot_cur->ctrl->ending_slot_num > first_slot) && (slot_num > slot_cur->ctrl->ending_slot_num)) 
 				first_slot = slot_cur->ctrl->ending_slot_num;
@@ -963,7 +963,7 @@ static int __init ebda_rsrc_controller (
 
 	}			/* each hpc  */
 
-	list_for_each_entry (tmp_slot, &ibmphp_slot_head, ibm_slot_list) {
+	list_for_each_entry(tmp_slot, &ibmphp_slot_head, ibm_slot_list) {
 		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
 		pci_hp_register(tmp_slot->hotplug_slot,
 			pci_find_bus(0, tmp_slot->bus), tmp_slot->device);
@@ -1066,7 +1066,7 @@ struct slot *ibmphp_get_slot_from_physic
 {
 	struct slot *slot;
 
-	list_for_each_entry (slot, &ibmphp_slot_head, ibm_slot_list) {
+	list_for_each_entry(slot, &ibmphp_slot_head, ibm_slot_list) {
 		if (slot->number == physical_num)
 			return slot;
 	}
@@ -1083,7 +1083,7 @@ struct bus_info *ibmphp_find_same_bus_nu
 {
 	struct bus_info *ptr;
 
-	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {
+	list_for_each_entry(ptr, &bus_info_head, bus_info_list) {
 		if (ptr->busno == num) 
 			 return ptr;
 	}
@@ -1097,7 +1097,7 @@ int ibmphp_get_bus_index (u8 num)
 {
 	struct bus_info *ptr;
 
-	list_for_each_entry (ptr, &bus_info_head, bus_info_list) {
+	list_for_each_entry(ptr, &bus_info_head, bus_info_list) {
 		if (ptr->busno == num)  
 			return ptr->index;
 	}
@@ -1172,7 +1172,7 @@ int ibmphp_register_pci (void)
 	struct controller *ctrl;
 	int rc = 0;
 
-	list_for_each_entry (ctrl, &ebda_hpc_head, ebda_hpc_list) {
+	list_for_each_entry(ctrl, &ebda_hpc_head, ebda_hpc_list) {
 		if (ctrl->ctlr_type == 1) {
 			rc = pci_register_driver(&ibmphp_driver);
 			break;
@@ -1186,7 +1186,7 @@ static int ibmphp_probe (struct pci_dev 
 
 	debug ("inside ibmphp_probe\n");
 	
-	list_for_each_entry (ctrl, &ebda_hpc_head, ebda_hpc_list) {
+	list_for_each_entry(ctrl, &ebda_hpc_head, ebda_hpc_list) {
 		if (ctrl->ctlr_type == 1) {
 			if ((dev->devfn == ctrl->u.pci_ctlr.dev_fun) && (dev->bus->number == ctrl->u.pci_ctlr.bus)) {
 				ctrl->ctrl_dev = dev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug-fix.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug-fix-fix.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
linux-next-git-rejects.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
e1000e-prevent-corruption-of-eeprom-nvm-fix.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

