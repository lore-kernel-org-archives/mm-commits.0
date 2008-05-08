From: akpm@linux-foundation.org
Subject: + aacraid-linitc-make-aac_show_serial_number-static.patch added to -mm tree
Date: Thu, 08 May 2008 13:37:24 -0700
Message-ID: <200805082037.m48KbOpn004653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbYEHUh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, aacraid@adaptec.com, mark_salyzyn@adaptec.com


The patch titled
     aacraid: linit.c: make aac_show_serial_number static
has been added to the -mm tree.  Its filename is
     aacraid-linitc-make-aac_show_serial_number-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aacraid: linit.c: make aac_show_serial_number static
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/scsi/aacraid/linit.c:865:9: warning: symbol 'aac_show_serial_number' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <aacraid@adaptec.com>
Cc: Salyzyn, Mark <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aacraid/linit.c~aacraid-linitc-make-aac_show_serial_number-static drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~aacraid-linitc-make-aac_show_serial_number-static
+++ a/drivers/scsi/aacraid/linit.c
@@ -862,7 +862,7 @@ static ssize_t aac_show_bios_version(str
 	return len;
 }
 
-ssize_t aac_show_serial_number(struct device *device,
+static ssize_t aac_show_serial_number(struct device *device,
 			       struct device_attribute *attr, char *buf)
 {
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(device)->hostdata;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
misc-fix-integer-as-null-pointer-warnings.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
git-alsa-tiwai.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

