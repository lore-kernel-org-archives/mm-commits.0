Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4689DC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiG3BNn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbiG3BN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DD08C159
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6832161D3F
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E9BC433C1;
        Sat, 30 Jul 2022 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143602;
        bh=KHVBF7hkw5F1ZdHUnvXPGbARpyL+3oUnB6izrZCOG9w=;
        h=Date:To:From:Subject:From;
        b=jqDh+2/N+gU2GaDrDI3lV6hkuJj+VBf/ayQ8d/+0hANpwMkPNWC1Z4XcibaRchqQs
         tb2dneNKSH+b7yK4YqIZoPFb+kpuK10zbTlYJNh9s+Rv6u71F54yCa/FfsX0KG4yb7
         XyT5eK4XTZYuw/UKhYQx8ZqCpNMtFmLADbBU57n4=
Date:   Fri, 29 Jul 2022 18:13:22 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, dlatypov@google.com,
        davidgow@google.com, brendan.higgins@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-linuxdev-alias-for-brendan-higgins.patch removed from -mm tree
Message-Id: <20220730011322.B9E9BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add linux.dev alias for Brendan Higgins
has been removed from the -mm tree.  Its filename was
     mailmap-add-linuxdev-alias-for-brendan-higgins.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Higgins <brendan.higgins@linux.dev>
Subject: mailmap: add linux.dev alias for Brendan Higgins
Date: Mon, 25 Jul 2022 17:58:33 -0400

Because of my new work remote setup at Google, I can no longer use command
line tools with my google.com email address, for this reason I got a
linux.dev account.  So update the mailmap to show the new alias I will be
using.

Link: https://lkml.kernel.org/r/20220725215833.789133-1-brendan.higgins@linux.dev
Signed-off-by: Brendan Higgins <brendan.higgins@linux.dev>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-linuxdev-alias-for-brendan-higgins
+++ a/.mailmap
@@ -71,6 +71,7 @@ Boris Brezillon <bbrezillon@kernel.org>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
+Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
 Brian Avery <b.avery@hp.com>
 Brian King <brking@us.ibm.com>
 Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
_

Patches currently in -mm which might be from brendan.higgins@linux.dev are


