Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A485C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Sep 2021 23:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634616103B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Sep 2021 23:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbhI0X37 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 19:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238012AbhI0X36 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 19:29:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2273761178;
        Mon, 27 Sep 2021 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632785300;
        bh=Cbuh1LrmSFWBRleg9i4dqyWjNakV8oJOj539IpNOzPE=;
        h=Date:From:To:Subject:From;
        b=ZgVrEBArpUkN+V7xkvdr8pqaUiNCi/Kc50MF4BvV0nlBgy6u5GIiGTIoPV3qB5+5U
         LO85MHcKbBC7xfzhQrRompgM0rBi4h6gQaQJO1Ajhx5z3FA5D4uyF8I7xCpxI26wJB
         /MXMVXTmQSQNTpf36iBw3cE0oqnKWIEYJpjiZsCM=
Date:   Mon, 27 Sep 2021 16:28:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210927232819.y6kGIVaym%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next-git-rejects.patch

