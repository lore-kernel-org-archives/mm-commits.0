Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA4FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 19:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD7E61139
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 19:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbhI1TrK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 15:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242539AbhI1TrK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 15:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA12E61139;
        Tue, 28 Sep 2021 19:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632858330;
        bh=SCce4iMKN8AhuOkNbU7WuZnRiIHnaRftguaIOD/UX14=;
        h=Date:From:To:Subject:From;
        b=W2qD9uJGwOrQuvnA3PT05Hls2s6tM3bgjC1AwBO1YVbKe961XCimsQHvsv5OyeI5j
         Hkzm90pSgBRh/T/PDvTbqX4xmYUJM9C4TQx8Lu3/VYciRgtpLJfrSzrunyKQGhG0Tg
         DrNsNmlR65At4Ew3/iCtMFbFY9p1wDfUq+3DEsy0=
Date:   Tue, 28 Sep 2021 12:45:30 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210928194530.sMSU3Qsph%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c |    4 ----
 drivers/media/rc/ir_toy.c              |    4 ----
 2 files changed, 8 deletions(-)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c~linux-next-git-rejects
+++ a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -265,13 +265,9 @@ static int amd_mp2_pci_probe(struct pci_
 	if (rc)
 		return rc;
 
-<<<<<<< HEAD
-	return devm_add_action_or_reset(&pdev->dev, amd_mp2_pci_remove, privdata);
-=======
 	mp2_select_ops(privdata);
 
 	return 0;
->>>>>>> linux-next/akpm-base
 }
 
 static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
--- a/drivers/media/rc/ir_toy.c~linux-next-git-rejects
+++ a/drivers/media/rc/ir_toy.c
@@ -329,11 +329,7 @@ static int irtoy_tx(struct rc_dev *rc, u
 	// with its led on. It does not respond to any command when this
 	// happens. To work around this, re-enter sample mode.
 	err = irtoy_command(irtoy, COMMAND_SMODE_EXIT,
-<<<<<<< HEAD
-			    sizeof(COMMAND_SMODE_EXIT), STATE_RESET);
-=======
 			    sizeof(COMMAND_SMODE_EXIT), STATE_COMMAND_NO_RESP);
->>>>>>> linux-next/akpm-base
 	if (err) {
 		dev_err(irtoy->dev, "exit sample mode: %d\n", err);
 		return err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

