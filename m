From: akpm@linux-foundation.org
Subject: [merged] kvm-fix-build-error-add-missing-semi-colon.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:58 -0700
Message-ID: <200905131831.n4DIVwwS018655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbZEMSfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, avi@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     kvm: fix build error: add missing semi-colon
has been removed from the -mm tree.  Its filename was
     kvm-fix-build-error-add-missing-semi-colon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: fix build error: add missing semi-colon
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing ; to fix build error:

arch/x86/kvm/x86.c:1259: error: expected',' or ';' before 'const'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kvm/x86.c~kvm-fix-build-error-add-missing-semi-colon arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~kvm-fix-build-error-add-missing-semi-colon
+++ a/arch/x86/kvm/x86.c
@@ -1252,7 +1252,7 @@ static void do_cpuid_ent(struct kvm_cpui
 #ifdef CONFIG_X86_64
 	unsigned f_lm = F(LM);
 #else
-	unsigned f_lm = 0
+	unsigned f_lm = 0;
 #endif
 
 	/* cpuid 1.edx */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
slqbinfo-eliminate-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

