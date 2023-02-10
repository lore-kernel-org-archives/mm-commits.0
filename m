Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFCFC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 01:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjBJBFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 20:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjBJBFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 20:05:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16E75CBFF
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 17:05:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D76061BED
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 01:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D7CC433D2;
        Fri, 10 Feb 2023 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675991102;
        bh=RP6HWGNTk3bGtGdwXYvI+zoMhkP++kZb/NKqS2hEvlo=;
        h=Date:To:From:Subject:From;
        b=iluqgLaXx8fWaeb1skcmaXvSklYAXnSsPVveU5f9Aiap1W9/Gqcp/wCmWrbMKUUOS
         buUK0nfb0aaI/XX6Fs1RUbroisjmS4AJiqK3LhiQzfdsRCDcHrxS7ro7J9Yw5c+bCU
         YQ7t7nOuK0UvhgjTlDGnIZ0Jss8pvKYoKVw6tl3w=
Date:   Thu, 09 Feb 2023 17:05:02 -0800
To:     mm-commits@vger.kernel.org, jesperjuhl76@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] update-credits-file-entry-for-jesper-juhl.patch removed from -mm tree
Message-Id: <20230210010502.A2D7CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Update CREDITS file entry for Jesper Juhl
has been removed from the -mm tree.  Its filename was
     update-credits-file-entry-for-jesper-juhl.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jesper Juhl <jesperjuhl76@gmail.com>
Subject: Update CREDITS file entry for Jesper Juhl

Link: https://lkml.kernel.org/r/8e18fa82-1095-330f-29fb-80743d22443c@gmail.com
Signed-off-by: Jesper Juhl <jesperjuhl76@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/CREDITS~update-credits-file-entry-for-jesper-juhl
+++ a/CREDITS
@@ -1848,11 +1848,11 @@ E: ajoshi@shell.unixbox.com
 D: fbdev hacking
 
 N: Jesper Juhl
-E: jj@chaosbits.net
+E: jesperjuhl76@gmail.com
 D: Various fixes, cleanups and minor features all over the tree.
 D: Wrote initial version of the hdaps driver (since passed on to others).
-S: Lemnosvej 1, 3.tv
-S: 2300 Copenhagen S.
+S: Titangade 5G, 2.tv
+S: 2200 Copenhagen N.
 S: Denmark
 
 N: Jozsef Kadlecsik
_

Patches currently in -mm which might be from jesperjuhl76@gmail.com are


