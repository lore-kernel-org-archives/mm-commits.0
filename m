From: akpm@osdl.org
Subject: - kvm-virtualization-infrastructure-include-desch.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:08 -0800
Message-ID: <200612100752.kBA7q8K4017627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760385AbWLJHwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon.kagstrom@bth.se, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Include desc.h
has been removed from the -mm tree.  Its filename was
     kvm-virtualization-infrastructure-include-desch.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Include desc.h
From: Simon Kagstrom <simon.kagstrom@bth.se>

This fixes compilation on some (32-bit) .configs.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-include-desch drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-include-desch
+++ a/drivers/kvm/kvm_main.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/file.h>
+#include <asm/desc.h>
 
 #include "vmx.h"
 #include "x86_emulate.h"
_

Patches currently in -mm which might be from simon.kagstrom@bth.se are

kvm-userspace-interface.patch
kvm-virtualization-infrastructure-include-desch.patch
kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches.patch

