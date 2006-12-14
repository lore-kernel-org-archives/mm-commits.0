From: akpm@osdl.org
Subject: - kvm-add-maintainers-entry.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:02:35 -0800
Message-ID: <200612140602.kBE62Z9u001755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbWLNGCs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:02:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Add MAINTAINERS entry
has been removed from the -mm tree.  Its filename was
     kvm-add-maintainers-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Add MAINTAINERS entry
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~kvm-add-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~kvm-add-maintainers-entry
+++ a/MAINTAINERS
@@ -1747,6 +1747,13 @@ W:	http://nfs.sourceforge.net/
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

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

