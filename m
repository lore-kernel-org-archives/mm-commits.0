From: akpm@linux-foundation.org
Subject: [merged] mips-define-kvm_user_mem_slots.patch removed from -mm tree
Date: Mon, 15 Apr 2013 13:04:41 -0700
Message-ID: <20130415200441.84C765A41D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53343 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DOUEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:04:43 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so504112vbb.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:04:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanjayl@kymasys.com, akpm@linux-foundation.org, alex.williamson@redhat.com, gleb@redhat.com, mtosatti@redhat.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: define KVM_USER_MEM_SLOTS
has been removed from the -mm tree.  Its filename was
     mips-define-kvm_user_mem_slots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sanjay Lal <sanjayl@kymasys.com>
Subject: mips: define KVM_USER_MEM_SLOTS

ARCH=mips, config=fuloong2e_defconfig:

akpm3:/usr/src/25> make arch/mips/kernel/early_printk.o
...
CC      arch/mips/kernel/asm-offsets.s
In file included from arch/mips/kernel/asm-offsets.c:20:
include/linux/kvm_host.h:334: error: `KVM_USER_MEM_SLOTS' undeclared here (not in a function)

Signed-off-by: Sanjay Lal <sanjayl@kymasys.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/include/asm/kvm_host.h~mips-define-kvm_user_mem_slots arch/mips/include/asm/kvm_host.h
--- a/arch/mips/include/asm/kvm_host.h~mips-define-kvm_user_mem_slots
+++ a/arch/mips/include/asm/kvm_host.h
@@ -21,7 +21,7 @@
 
 
 #define KVM_MAX_VCPUS		1
-#define KVM_MEMORY_SLOTS	8
+#define KVM_USER_MEM_SLOTS	8
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 	0
 
_

Patches currently in -mm which might be from sanjayl@kymasys.com are

linux-next.patch

