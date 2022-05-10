Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7927BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiEJENv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbiEJENc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:13:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043E020956E
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6774D615E8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2E8C385A6;
        Tue, 10 May 2022 04:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155775;
        bh=IbKOOObgkSPLTZU1TJXFzgZ+qCHj//CE/JFPvdDVnvA=;
        h=Date:To:From:Subject:From;
        b=2rEv6gaUPpiQlgI+AEwxD2HKoUhU7+Fe4bTEPo9RKXsn2NKhBPtc0rZ0laV4gZe2i
         6RVxzkzHC6FtIQ13FWnVnlyRRIuypnDZTMAq8vzRqQRlxNtW2+5KFx8zmdB+A7htn3
         wXGXvdfE4r3fBNrOe5mmdORTgKSR1ON/w5g2DY2A=
Date:   Mon, 09 May 2022 21:09:35 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-a-mailing-list-for-damon-development.patch removed from -mm tree
Message-Id: <20220510040935.BA2E8C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add a mailing list for DAMON development
has been removed from the -mm tree.  Its filename was
     maintainers-add-a-mailing-list-for-damon-development.patch

This patch was dropped because it was merged into mm-hotfixes-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: add a mailing list for DAMON development

This commit adds an open mailing list for DAMON in MAINTAINERS file.

Link: https://lkml.kernel.org/r/20220503180741.137079-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-a-mailing-list-for-damon-development
+++ a/MAINTAINERS
@@ -5438,6 +5438,7 @@ F:	net/ax25/sysctl_net_ax25.c
 
 DATA ACCESS MONITOR
 M:	SeongJae Park <sj@kernel.org>
+L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
_

Patches currently in -mm which might be from sj@kernel.org are


