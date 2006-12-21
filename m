From: akpm@osdl.org
Subject: - kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch removed from -mm tree
Date: Thu, 21 Dec 2006 14:21:31 -0800
Message-ID: <200612212221.kBLMLaQ9006868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46939 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423121AbWLUWWK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 17:22:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, avi@qumranet.com, michael@mr511.de, mm-commits@vger.kernel.org


The patch titled
     kvm-do-not-export-unsupported-msrs-to-userspace-tweak
has been removed from the -mm tree.  Its filename was
     kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch

This patch was dropped because it was folded into kvm-do-not-export-unsupported-msrs-to-userspace.patch

------------------------------------------------------
Subject: kvm-do-not-export-unsupported-msrs-to-userspace-tweak
From: Andrew Morton <akpm@osdl.org>

Cc: Michael Riepe <michael@mr511.de>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-do-not-export-unsupported-msrs-to-userspace-tweak drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-do-not-export-unsupported-msrs-to-userspace-tweak
+++ a/drivers/kvm/kvm_main.c
@@ -1430,7 +1430,7 @@ static u32 msrs_to_save[] = {
 	MSR_IA32_TIME_STAMP_COUNTER,
 };
 
-static unsigned num_msrs_to_save = 0;
+static unsigned num_msrs_to_save;
 
 static __init void kvm_init_msr_list(void)
 {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
kvm-do-not-export-unsupported-msrs-to-userspace.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch

