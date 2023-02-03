Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750D0C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjBCGfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjBCGfa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0CD4C0F1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EFF3CE2EC0
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A96C4339B;
        Fri,  3 Feb 2023 06:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406121;
        bh=OjTJDInZSa0vUrZKjooMdF2TNLmidBdC1upKMf8ztRk=;
        h=Date:To:From:Subject:From;
        b=Z6r24hOoKLx2RAQZkyCLDCZVhTAwxk1A4eYe4aFyjO/HWLxnFvMJySlKYV82QPEn5
         ERtwo8TzRoDBnZSokaVxWdMe6HYDlBJsQQqj3le7FLGopid3phB9YnOTJYe4amA4mg
         I0fHcEWSqAFCeDb4jzo9g2YnshqRZ5/LNbDqFzoY=
Date:   Thu, 02 Feb 2023 22:35:20 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-damon-link-maintainer-profile-git-trees-and-website.patch removed from -mm tree
Message-Id: <20230203063521.70A96C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS/DAMON: link maintainer profile, git trees, and website
has been removed from the -mm tree.  Its filename was
     maintainers-damon-link-maintainer-profile-git-trees-and-website.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS/DAMON: link maintainer profile, git trees, and website
Date: Tue, 10 Jan 2023 19:03:58 +0000

Add links to below DAMON development related resource to DAMON section in
MAINTAINERS file.

- The basic policies and expectations of DAMON development,
- DAMON development trees, and
- DAMON introduction website.

Link: https://lkml.kernel.org/r/20230110190400.119388-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/MAINTAINERS~maintainers-damon-link-maintainer-profile-git-trees-and-website
+++ a/MAINTAINERS
@@ -5790,6 +5790,11 @@ M:	SeongJae Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
 S:	Maintained
+W:	https://damonitor.github.io
+P:	Documentation/mm/damon/maintainer-profile.rst
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
 F:	Documentation/admin-guide/mm/damon/
 F:	Documentation/mm/damon/
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

