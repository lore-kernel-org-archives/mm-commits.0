From: akpm@linux-foundation.org
Subject: + parport-remove-cvs-keywords.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:52:26 -0700
Message-ID: <200808062252.m76MqQSC019737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725AbYHFWwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     parport: remove CVS keywords
has been added to the -mm tree.  Its filename is
     parport-remove-cvs-keywords.patch

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
Subject: parport: remove CVS keywords
From: Adrian Bunk <bunk@kernel.org>

Remove CVS keywords that weren't updated for a long time from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/ieee1284.c |    2 +-
 drivers/parport/probe.c    |    2 +-
 drivers/parport/share.c    |    2 +-
 include/linux/parport.h    |    2 --
 4 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/parport/ieee1284.c~parport-remove-cvs-keywords drivers/parport/ieee1284.c
--- a/drivers/parport/ieee1284.c~parport-remove-cvs-keywords
+++ a/drivers/parport/ieee1284.c
@@ -1,4 +1,4 @@
-/* $Id: parport_ieee1284.c,v 1.4 1997/10/19 21:37:21 philip Exp $
+/*
  * IEEE-1284 implementation for parport.
  *
  * Authors: Phil Blundell <philb@gnu.org>
diff -puN drivers/parport/probe.c~parport-remove-cvs-keywords drivers/parport/probe.c
--- a/drivers/parport/probe.c~parport-remove-cvs-keywords
+++ a/drivers/parport/probe.c
@@ -1,4 +1,4 @@
-/* $Id: parport_probe.c,v 1.1 1999/07/03 08:56:17 davem Exp $
+/*
  * Parallel port device probing code
  *
  * Authors:    Carsten Gross, carsten@sol.wohnheim.uni-ulm.de
diff -puN drivers/parport/share.c~parport-remove-cvs-keywords drivers/parport/share.c
--- a/drivers/parport/share.c~parport-remove-cvs-keywords
+++ a/drivers/parport/share.c
@@ -1,4 +1,4 @@
-/* $Id: parport_share.c,v 1.15 1998/01/11 12:06:17 philip Exp $
+/*
  * Parallel-port resource manager code.
  * 
  * Authors: David Campbell <campbell@tirian.che.curtin.edu.au>
diff -puN include/linux/parport.h~parport-remove-cvs-keywords include/linux/parport.h
--- a/include/linux/parport.h~parport-remove-cvs-keywords
+++ a/include/linux/parport.h
@@ -1,5 +1,3 @@
-/* $Id: parport.h,v 1.1 1998/05/17 10:57:52 andrea Exp andrea $ */
-
 /*
  * Any part of this program may be used in documents licensed under
  * the GNU Free Documentation License, Version 1.1 or any later version
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch
fs-partitions-acornc-remove-dead-code.patch
the-overdue-eepro100-removal.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
parport-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
ntfs-update-homepage.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
binfmt_somc-add-module_license.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
the-scheduled-serial_coldfire-removal.patch

