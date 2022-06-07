Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288CCCCA47C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 01:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376379AbiFHBKH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588477AbiFGXym (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 19:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3B54FC47
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 16:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C8F66164B
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 23:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81497C3411C;
        Tue,  7 Jun 2022 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654643480;
        bh=G6jM77yz41C7p279PkfKdtNwn4pk5wfmdK7yOW5d864=;
        h=Date:To:From:Subject:From;
        b=KoTqkcKnpW2gK3Xh+aEZuCs3Gk042aLL+fQap0kP6o1zV9yShW8827CFcgu4ME4F+
         d8RuR5c5xUCaoZLWT4AJI8V+SzyuMcQnkmDqMnJpHJg/VyQTM1jLm8JDj6Z5Ns4sLx
         GHGoJ26vO3kfGh3fMMV0sJ9HzABPR6724ZOQhQt4=
Date:   Tue, 07 Jun 2022 16:11:19 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@Oracle.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-5.patch added to mm-unstable branch
Message-Id: <20220607231120.81497C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove an obvious typo in MAPLE TREE
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-5.patch

This patch will later appear in the mm-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: remove an obvious typo in MAPLE TREE
Date: Tue, 7 Jun 2022 08:38:34 +0200

Commit c6e2362e9289 ("Maple Tree: add new data structure") adds the maple
tree and a corresponding MAINTAINERS section, but slips in an obvious
typo.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Remove this obvious typo in MAPLE TREE.

Link: https://lkml.kernel.org/r/20220607063834.7004-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maple-tree-add-new-data-structure-fix-5
+++ a/MAINTAINERS
@@ -11790,7 +11790,7 @@ F:	include/linux/maple_tree.h
 F:	include/trace/events/maple_tree.h
 F:	lib/maple_tree.c
 F:	lib/test_maple_tree.c
-F:	tools/testing/_adix-tree/linux/maple_tree.h
+F:	tools/testing/radix-tree/linux/maple_tree.h
 F:	tools/testing/radix-tree/maple.c
 
 MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maple-tree-add-new-data-structure-fix-5.patch

