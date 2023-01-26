Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC463C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 20:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjAZUxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 15:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjAZUxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 15:53:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C835B27489
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 12:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6438B6182F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 20:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB68FC433EF;
        Thu, 26 Jan 2023 20:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674766397;
        bh=NER9LsU6n4c6SW5OtVzKw88+LN4VgL8Mnflssu9moIA=;
        h=Date:To:From:Subject:From;
        b=YYMbVzagFQHwLxCai0nF6WlbqNGMM1tGCzgW9ApkEzfTfMdMBXf7cb8eNHENtYR5H
         G8mf2gPPxvNCVW5kvLvNiENoKSzSXtapWbKuFj9CFT12IiT1+AaLmDocD/6q3DgPuc
         +QmmOUNy+eJnVrKK1+krYrpyfpuxchv2A/A7MrLA=
Date:   Thu, 26 Jan 2023 12:53:17 -0800
To:     mm-commits@vger.kernel.org, luca.ceresoli@bootlin.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances.patch added to mm-nonmm-unstable branch
Message-Id: <20230126205317.BB68FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "exsits" pattern and fix typo instances
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/spelling.txt: add "exsits" pattern and fix typo instances
Date: Thu, 26 Jan 2023 16:22:05 +0100

Fix typos and add the following to the scripts/spelling.txt:

  exsits||exists

Link: https://lkml.kernel.org/r/20230126152205.959277-1-luca.ceresoli@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 net/openvswitch/flow_table.c             |    2 +-
 scripts/spelling.txt                     |    1 +
 sound/soc/fsl/fsl-asoc-card.c            |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/ulp/iser/iscsi_iser.c~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -446,7 +446,7 @@ iscsi_iser_conn_create(struct iscsi_cls_
  * @is_leading:      indicate if this is the session leading connection (MCS)
  *
  * Return: zero on success, $error if iscsi_conn_bind fails and
- *         -EINVAL in case end-point doesn't exsits anymore or iser connection
+ *         -EINVAL in case end-point doesn't exists anymore or iser connection
  *         state is not UP (teardown already started).
  */
 static int iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
--- a/net/openvswitch/flow_table.c~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/net/openvswitch/flow_table.c
@@ -1012,7 +1012,7 @@ static int flow_mask_insert(struct flow_
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		/* Allocate a new mask if none exsits. */
+		/* Allocate a new mask if none exists. */
 		mask = mask_alloc();
 		if (!mask)
 			return -ENOMEM;
--- a/scripts/spelling.txt~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -630,6 +630,7 @@ exeuction||execution
 existance||existence
 existant||existent
 exixt||exist
+exsits||exists
 exlcude||exclude
 exlcusive||exclusive
 exlusive||exclusive
--- a/sound/soc/fsl/fsl-asoc-card.c~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/sound/soc/fsl/fsl-asoc-card.c
@@ -811,7 +811,7 @@ static int fsl_asoc_card_probe(struct pl
 	priv->card.num_links = 1;
 
 	if (asrc_pdev) {
-		/* DPCM DAI Links only if ASRC exsits */
+		/* DPCM DAI Links only if ASRC exists */
 		priv->dai_link[1].cpus->of_node = asrc_np;
 		priv->dai_link[1].platforms->of_node = asrc_np;
 		priv->dai_link[2].codecs->dai_name = codec_dai_name;
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are

scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances.patch

