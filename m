From: akpm@linux-foundation.org
Subject: + acer-wmi-remove-non-used-acer_quirks-struct-definition.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:18:17 -0700
Message-ID: <201007122318.o6CNIH9r002830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab0GLX0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan-jenkins@tuffmail.co.uk, carlos@strangeworlds.co.uk, mjg@redhat.com, trenn@suse.de


The patch titled
     acer-wmi: remove non-used acer_quirks struct definition
has been added to the -mm tree.  Its filename is
     acer-wmi-remove-non-used-acer_quirks-struct-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acer-wmi: remove non-used acer_quirks struct definition
From: Axel Lin <axel.lin@gmail.com>

Remove non-used acer_quirks struct definition.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-remove-non-used-acer_quirks-struct-definition drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-remove-non-used-acer_quirks-struct-definition
+++ a/drivers/platform/x86/acer-wmi.c
@@ -50,17 +50,6 @@ MODULE_LICENSE("GPL");
 #define ACER_INFO KERN_INFO ACER_LOGPREFIX
 
 /*
- * The following defines quirks to get some specific functions to work
- * which are known to not be supported over ACPI-WMI (such as the mail LED
- * on WMID based Acer's)
- */
-struct acer_quirks {
-	const char *vendor;
-	const char *model;
-	u16 quirks;
-};
-
-/*
  * Magic Number
  * Meaning is unknown - this number is required for writing to ACPI for AMW0
  * (it's also used in acerhk when directly accessing the BIOS)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch
asus_acpi-fix-a-memory-leak-in-asus_hotk_get_info.patch
asus_acpi-fix-coding-style-to-improve-readability.patch
acerhdf-make-needlessly-global-symbols-static.patch
classmate-laptop-make-needlessly-global-symbols-static.patch
fujitsu-laptop-make-needlessly-global-symbols-static.patch
msi-laptop-make-struct-rfkill_ops-const.patch
asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null.patch
asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail.patch
acerhdf-fix-resource-reclaim-in-error-path.patch
toshiba_acpi-make-remove_device-and-add_device-void.patch
toshiba_acpi-rename-add_device-and-remove_device-to-create_toshiba_proc_entries-and-remove_toshiba_proc_entries.patch
hp-wmi-add-return-value-checking-for-input_allocate_device.patch
acer-wmi-fix-memory-leaks-in-wmid_set_capabilities-and-get_wmid_devices.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch
acer-wmi-remove-non-used-acer_quirks-struct-definition.patch
asus-laptop-fix-wapf-wlan_status-and-bluetooth_status-module_param-permissions.patch
eeepc-laptop-fix-hotplug_disabled-module_param-permissions.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
edd-fix-possible-memory-leak-in-edd_init-error-path.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch

