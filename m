From: akpm@osdl.org
Subject: - kvm-add-missing-break.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:17 -0800
Message-ID: <200701070800.l0780H1C013174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbXAGIAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Add missing 'break'
has been removed from the -mm tree.  Its filename was
     kvm-add-missing-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Add missing 'break'
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/kvm_main.c~kvm-add-missing-break drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-missing-break
+++ a/drivers/kvm/kvm_main.c
@@ -1922,6 +1922,7 @@ static long kvm_dev_ioctl(struct file *f
 				 num_msrs_to_save * sizeof(u32)))
 			goto out;
 		r = 0;
+		break;
 	}
 	default:
 		;
_

Patches currently in -mm which might be from avi@qumranet.com are
