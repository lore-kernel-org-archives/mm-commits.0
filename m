Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C1EC05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 02:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBGCol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 21:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBGCol (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 21:44:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07330287
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 18:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8CB5CE1C91
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 02:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2679CC433EF;
        Tue,  7 Feb 2023 02:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675737870;
        bh=YzX7LLtHUgKAUpArJxhmv9BufljbMw3rgrAyaDQMOHU=;
        h=Date:To:From:Subject:From;
        b=wktDlWR6K33OxmaHtGgWDozISZF8nfE9A/KYOC4zWG3adNKP9IfZ9gEiswaaShdZk
         vKGBV4VywcRu3ACk1jE7cXHiEur4AYaX3Yj3O/iv/QR1PW7AFYMHbHgQcpGJp8UqKH
         dTNu9Ivfw/IsQGcgkHv+0tesYNORZjg16uwrqP7E=
Date:   Mon, 06 Feb 2023 18:44:29 -0800
To:     mm-commits@vger.kernel.org, jesperjuhl76@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + update-credits-file-entry-for-jesper-juhl.patch added to mm-nonmm-unstable branch
Message-Id: <20230207024430.2679CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Update CREDITS file entry for Jesper Juhl
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     update-credits-file-entry-for-jesper-juhl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/update-credits-file-entry-for-jesper-juhl.patch

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
From: Jesper Juhl <jesperjuhl76@gmail.com>
Subject: Update CREDITS file entry for Jesper Juhl

Link: https://lkml.kernel.org/r/8e18fa82-1095-330f-29fb-80743d22443c@gmail.com
Signed-off-by: Jesper Juhl <jesperjuhl76@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

update-credits-file-entry-for-jesper-juhl.patch

