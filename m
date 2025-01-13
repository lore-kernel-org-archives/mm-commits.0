Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3C325761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742192; cv=none; b=SomGY3uSNhFK5rWBxvhdw4kbDkw3g6njzq3/BQjUcEDnCaAy4tfu67gNtbLx9jYlEs8VHlWHgZwvkk+AdVT/bMKBEByElj8bOUOtfJpEQlJkJtTVDLiv92YvMw6oOa1ReVS3UQqaJ4c0SxRWVIsUllWIokjo2s5e8s5L7OFPJDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742192; c=relaxed/simple;
	bh=758nzJ59wNa8byJKC5eNzJr9e9Aw0/5cyqi3b2Beptw=;
	h=Date:To:From:Subject:Message-Id; b=cJtVZiYGpTEhj9DVkDsD0cW9xJ13R1gJfuwhhUNmmpwjTstUiyuosvzWbeEdTSkKbYVBrrzGlsRU29e0uLuEg1KYiR8Y1Vqum1vJ911Z+Pl23NXTqKhTMYpMm8lauUy2JR1wNLBt4l4Nt6dhzRHuTnQNoyTEw5Wylgaj0QHSyg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIRmcBlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIRmcBlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9008EC4CED6;
	Mon, 13 Jan 2025 04:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742192;
	bh=758nzJ59wNa8byJKC5eNzJr9e9Aw0/5cyqi3b2Beptw=;
	h=Date:To:From:Subject:From;
	b=SIRmcBlmEAqeaj3jiCewEMOv9N8XXwv0QH/J8soouKnHT254jFAptTm4YH6rEW6dc
	 wp+Y5u3UPeFSEagCDSYunVtgcgkL2hdHDx0TD4htfa/u4u4FbF+oGpLkN1dbXVtOUX
	 meAKVfkhnfz7JSWOztGXEcFoDqorrmuI058GiAtA=
Date: Sun, 12 Jan 2025 20:23:12 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,leon@kernel.org,jgg@ziepe.ca,dennis.dalessandro@cornelisnetworks.com,colin.i.king@gmail.com,christophe.leroy@csgroup.eu,cvam0000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-wide-add-explicityexplicitly-to-spellingtxt.patch removed from -mm tree
Message-Id: <20250113042312.9008EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel-wide: add explicity||explicitly to spelling.txt
has been removed from the -mm tree.  Its filename was
     kernel-wide-add-explicityexplicitly-to-spellingtxt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivam Chaudhary <cvam0000@gmail.com>
Subject: kernel-wide: add explicity||explicitly to spelling.txt
Date: Wed, 11 Dec 2024 21:19:03 +0530

Correct the spelling dictionary so that future instances will be caught by
checkpatch, and fix the instances found.

Link: https://lkml.kernel.org/r/20241211154903.47027-1-cvam0000@gmail.com
Signed-off-by: Shivam Chaudhary <cvam0000@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Shivam Chaudhary <cvam0000@gmail.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv.c                                |    2 +-
 drivers/infiniband/hw/hfi1/iowait.h                         |    2 +-
 drivers/infiniband/hw/usnic/usnic_abi.h                     |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c |    2 +-
 drivers/scsi/cxlflash/superpipe.c                           |    2 +-
 scripts/spelling.txt                                        |    1 +
 tools/testing/selftests/pidfd/pidfd_test.c                  |    2 +-
 7 files changed, 7 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -4957,7 +4957,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcp
 			 * states are synchronized from L0 to L1. L1 needs to inform L0 about
 			 * MER=1 only when there are pending external interrupts.
 			 * In the above if check, MER bit is set if there are pending
-			 * external interrupts. Hence, explicity mask off MER bit
+			 * external interrupts. Hence, explicitly mask off MER bit
 			 * here as otherwise it may generate spurious interrupts in L2 KVM
 			 * causing an endless loop, which results in L2 guest getting hung.
 			 */
--- a/drivers/infiniband/hw/hfi1/iowait.h~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/drivers/infiniband/hw/hfi1/iowait.h
@@ -92,7 +92,7 @@ struct iowait_work {
  *
  * The lock field is used by waiters to record
  * the seqlock_t that guards the list head.
- * Waiters explicity know that, but the destroy
+ * Waiters explicitly know that, but the destroy
  * code that unwaits QPs does not.
  */
 struct iowait {
--- a/drivers/infiniband/hw/usnic/usnic_abi.h~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -72,7 +72,7 @@ struct usnic_ib_create_qp_resp {
 	u64				bar_bus_addr;
 	u32				bar_len;
 /*
- * WQ, RQ, CQ are explicity specified bc exposing a generic resources inteface
+ * WQ, RQ, CQ are explicitly specified bc exposing a generic resources inteface
  * expands the scope of ABI to many files.
  */
 	u32				wq_cnt;
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1810,7 +1810,7 @@ void brcmf_fws_rxreorder(struct brcmf_if
 			rfi->cur_idx = cur_idx;
 		}
 	} else {
-		/* explicity window move updating the expected index */
+		/* explicitly window move updating the expected index */
 		exp_idx = reorder_data[BRCMF_RXREORDER_EXPIDX_OFFSET];
 
 		brcmf_dbg(DATA, "flow-%d (0x%x): change expected: %d -> %d\n",
--- a/drivers/scsi/cxlflash/superpipe.c~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/drivers/scsi/cxlflash/superpipe.c
@@ -966,7 +966,7 @@ static int cxlflash_disk_detach(struct s
  *
  * This routine is the release handler for the fops registered with
  * the CXL services on an initial attach for a context. It is called
- * when a close (explicity by the user or as part of a process tear
+ * when a close (explicitly by the user or as part of a process tear
  * down) is performed on the adapter file descriptor returned to the
  * user. The user should be aware that explicitly performing a close
  * considered catastrophic and subsequent usage of the superpipe API
--- a/scripts/spelling.txt~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -678,6 +678,7 @@ exmaple||example
 expecially||especially
 experies||expires
 explicite||explicit
+explicity||explicitly
 explicitely||explicitly
 explict||explicit
 explictely||explicitly
--- a/tools/testing/selftests/pidfd/pidfd_test.c~kernel-wide-add-explicityexplicitly-to-spellingtxt
+++ a/tools/testing/selftests/pidfd/pidfd_test.c
@@ -497,7 +497,7 @@ static int child_poll_leader_exit_test(v
 	pthread_create(&t2, NULL, test_pidfd_poll_leader_exit_thread, NULL);
 
 	/*
-	 * glibc exit calls exit_group syscall, so explicity call exit only
+	 * glibc exit calls exit_group syscall, so explicitly call exit only
 	 * so that only the group leader exits, leaving the threads alone.
 	 */
 	*child_exit_secs = time(NULL);
_

Patches currently in -mm which might be from cvam0000@gmail.com are


