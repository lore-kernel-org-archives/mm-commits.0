Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB66C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiK3XxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiK3XxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6066320
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F5DDB81AD6
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0DAC433C1;
        Wed, 30 Nov 2022 23:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852396;
        bh=RvEr1jRKjCjje/LjR9aZtmqRYjm3/wkOpTJMjlH3qkE=;
        h=Date:To:From:Subject:From;
        b=iiBsa2XWJUJwSBjU5wSGONa246fjQ9r/MrbfIlk0SFa6I3cz7ysoNZeLXtX9wFfl9
         hI8WhdKvaNGEy0ficn0GuLOu8znnpv0Bv5tNCDZcnFxo7CwmdKdRn3KwH+FM2Sj4Zk
         ZjaCGvSrBCrU5BIjs/3MyRmind8pEPhEReKZGeA4=
Date:   Wed, 30 Nov 2022 15:53:15 -0800
To:     mm-commits@vger.kernel.org, shr@devkernel.io, sfr@canb.auug.org.au,
        clm@meta.com, axboe@kernel.dk, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch removed from -mm tree
Message-Id: <20221130235316.2D0DAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

This patch was dropped because it was folded into mm-document-sys-class-bdi-bdi-min_ratio_fine-knob.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix
Date: Tue Nov 22 02:59:02 PM PST 2022

fix htmldocs warnings

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -54,8 +54,8 @@ Description:
 
 	The 'min_ratio_fine' parameter allows assigning a minimum reserve
 	of the write-back cache to a particular device. The value is
-    expressed as part of 1 million. For example, this is useful for
-    providing a minimum QoS.
+	expressed as part of 1 million. For example, this is useful for
+	providing a minimum QoS.
 
 	(read-write)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-document-sys-class-bdi-bdi-min_ratio_fine-knob.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

