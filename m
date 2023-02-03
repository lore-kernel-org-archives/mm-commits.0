Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20DBC64EC4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjBCGwQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjBCGva (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A65F8D61F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A85F561DBB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B674C433D2;
        Fri,  3 Feb 2023 06:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407080;
        bh=pB5SSXqhTaKTwVnjIBEqp6mTA59Kkmu6hxyCF+fFuSI=;
        h=Date:To:From:Subject:From;
        b=GjMbV6F0OIYnE7oE7jPOOrS5beSO8TWwL3R6UftvGQzIo2F8UzVXya3gvSdP8/MB4
         K0OjEnolOqt8qzRm2FsJBa3JYx0FnAPpGuNsxJ0ldoRAkH1ExVweS3OTPOdx3nkjfF
         5kKkRuspeNRhW0OaxO47LwFoHMCM9i1v8ySGIXnE=
Date:   Thu, 02 Feb 2023 22:51:19 -0800
To:     mm-commits@vger.kernel.org, nico@fluxnic.net,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cramfs-kconfig-fix-spelling-punctuation.patch removed from -mm tree
Message-Id: <20230203065120.0B674C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cramfs: Kconfig: fix spelling & punctuation
has been removed from the -mm tree.  Its filename was
     cramfs-kconfig-fix-spelling-punctuation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: cramfs: Kconfig: fix spelling & punctuation
Date: Tue, 24 Jan 2023 10:16:31 -0800

Fix spelling and hyphenation in cramfs Kconfig.

Link: https://lkml.kernel.org/r/20230124181631.15204-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/cramfs/Kconfig~cramfs-kconfig-fix-spelling-punctuation
+++ a/fs/cramfs/Kconfig
@@ -38,7 +38,7 @@ config CRAMFS_MTD
 	default y if !CRAMFS_BLOCKDEV
 	help
 	  This option allows the CramFs driver to load data directly from
-	  a linear adressed memory range (usually non volatile memory
+	  a linear addressed memory range (usually non-volatile memory
 	  like flash) instead of going through the block device layer.
 	  This saves some memory since no intermediate buffering is
 	  necessary.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


