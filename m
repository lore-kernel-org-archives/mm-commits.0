From: akpm@osdl.org
Subject: + kvm-add-maintainers-entry.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:20:34 -0800
Message-ID: <200612112020.kBBKKYIi006096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937640AbWLKUUn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Add MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     kvm-add-maintainers-entry.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Add MAINTAINERS entry
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN MAINTAINERS~kvm-add-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~kvm-add-maintainers-entry
+++ a/MAINTAINERS
@@ -1745,6 +1745,13 @@ W:	http://nfs.sourceforge.net/
 W:	http://www.cse.unsw.edu.au/~neilb/patches/linux-devel/
 S:	Maintained
 
+KERNEL VIRTUAL MACHINE (KVM)
+P:	Avi Kivity
+M:	avi@qumranet.com
+L:	kvm-devel@lists.sourceforge.net
+W:	kvm.sourceforge.net
+S:	Supported
+
 KEXEC
 P:	Eric Biederman
 M:	ebiederm@xmission.com
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch
kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch
kvm-move-find_vmx_entry-to-vmxc.patch
kvm-remove-extranous-put_cpu-from-vcpu_put.patch
kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch
kvm-add-maintainers-entry.patch

