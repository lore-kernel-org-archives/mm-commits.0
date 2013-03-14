From: akpm@linux-foundation.org
Subject: + mips-define-kvm_user_mem_slots.patch added to -mm tree
Date: Thu, 14 Mar 2013 16:04:30 -0700
Message-ID: <20130314230430.7380631C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35540 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3CNXEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 19:04:31 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so300375qaj.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 16:04:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sanjayl@kymasys.com, akpm@linux-foundation.org, alex.williamson@redhat.com, gleb@redhat.com, mtosatti@redhat.com, ralf@linux-mips.org


The patch titled
     Subject: mips: define KVM_USER_MEM_SLOTS
has been added to the -mm tree.  Its filename is
     mips-define-kvm_user_mem_slots.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sanjay Lal <sanjayl@kymasys.com>
Subject: mips: define KVM_USER_MEM_SLOTS

ARCH=mips, config=fuloong2e_defconfig:

akpm3:/usr/src/25> make arch/mips/kernel/early_printk.o
...
CC      arch/mips/kernel/asm-offsets.s
In file included from arch/mips/kernel/asm-offsets.c:20:
include/linux/kvm_host.h:334: error: `KVM_USER_MEM_SLOTS' undeclared here (not in a function)

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
mips-define-kvm_user_mem_slots.patch

