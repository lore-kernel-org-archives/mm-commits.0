From: akpm@linux-foundation.org
Subject: + asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:09:58 -0800
Message-ID: <201001142309.o0EN9wsm004895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757156Ab0ANXLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:11:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, corentincj@iksaif.net, lenb@kernel.org, sziwan@users.sourceforge.net


The patch titled
     asus-acpi: remove duplicate comparison of asus_model strings
has been added to the -mm tree.  Its filename is
     asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch

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
Subject: asus-acpi: remove duplicate comparison of asus_model strings
From: Roel Kluin <roel.kluin@gmail.com>

These tests already occur elsewhere

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/asus_acpi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/platform/x86/asus_acpi.c~asus-acpi-remove-duplicate-comparison-of-asus_model-strings drivers/platform/x86/asus_acpi.c
--- a/drivers/platform/x86/asus_acpi.c~asus-acpi-remove-duplicate-comparison-of-asus_model-strings
+++ a/drivers/platform/x86/asus_acpi.c
@@ -1225,9 +1225,8 @@ static int asus_model_match(char *model)
 	else if (strncmp(model, "M2N", 3) == 0 ||
 		 strncmp(model, "M3N", 3) == 0 ||
 		 strncmp(model, "M5N", 3) == 0 ||
-		 strncmp(model, "M6N", 3) == 0 ||
 		 strncmp(model, "S1N", 3) == 0 ||
-		 strncmp(model, "S5N", 3) == 0 || strncmp(model, "W1N", 3) == 0)
+		 strncmp(model, "S5N", 3) == 0)
 		return xxN;
 	else if (strncmp(model, "M1", 2) == 0)
 		return M1A;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
musb-test-always-evaluates-to-false.patch
musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

