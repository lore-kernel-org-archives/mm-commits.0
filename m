From: akpm@linux-foundation.org
Subject: + fusion-fix-kernel-doc-warnings.patch added to -mm tree
Date: Thu, 27 May 2010 13:05:01 -0700
Message-ID: <201005272005.o4RK51qB011369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab0E0UFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 May 2010 16:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com


The patch titled
     fusion: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     fusion-fix-kernel-doc-warnings.patch

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
Subject: fusion: fix kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix (delete) empty kernel-doc lines/warnings:
Warning(drivers/message/fusion/mptbase.c:6916): bad line:
Warning(drivers/message/fusion/mptbase.c:7060): bad line:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~fusion-fix-kernel-doc-warnings drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~fusion-fix-kernel-doc-warnings
+++ a/drivers/message/fusion/mptbase.c
@@ -6914,7 +6914,6 @@ EXPORT_SYMBOL(mpt_halt_firmware);
  *	mpt_SoftResetHandler - Issues a less expensive reset
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@sleepFlag: Indicates if sleep or schedule must be called.
-
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  *
@@ -7058,7 +7057,6 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, i
  *	mpt_Soft_Hard_ResetHandler - Try less expensive reset
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@sleepFlag: Indicates if sleep or schedule must be called.
-
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  *	Try for softreset first, only if it fails go for expensive
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
documentation-submittingdrivers-resources.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
linux-next.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
fusion-fix-kernel-doc-warnings.patch
fs-super-fix-kernel-doc-warning.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

