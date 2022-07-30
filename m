Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666F7C19F2C
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbiG3BNo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiG3BN1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C328C177
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704D561D53
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D12C433C1;
        Sat, 30 Jul 2022 01:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143603;
        bh=4+gi9tnN3ZaNqupPkQdTUjf1GfRa7Tg+fRPkyLfT0PI=;
        h=Date:To:From:Subject:From;
        b=KmKLLre/D04S4fJoa21cKx4gEjf3JfmQquld+VqGP1SL+uK5+C7E0kFsIzOuYVUxX
         xMEmFIQkTQpohe6ZgGlbsLyfkaesgnLlnzulIaEDIogycFIfh403AT0nLJpAUJAF9B
         POjfETK05Oq+jMwTW7PZHcKSMOF70jiZc1E+zOUk=
Date:   Fri, 29 Jul 2022 18:13:23 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, dlatypov@google.com,
        davidgow@google.com, brendan.higgins@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit.patch removed from -mm tree
Message-Id: <20220730011323.C5D12C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: kunit: add David Gow as a maintainer of KUnit
has been removed from the -mm tree.  Its filename was
     maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Higgins <brendan.higgins@linux.dev>
Subject: MAINTAINERS: kunit: add David Gow as a maintainer of KUnit
Date: Mon, 25 Jul 2022 18:07:37 -0400

David has been a de facto maintainer of KUnit for a long time now.
Formalize this in the MAINTAINERS file.

Link: https://lkml.kernel.org/r/20220725220737.790976-1-brendan.higgins@linux.dev
Signed-off-by: Brendan Higgins <brendan.higgins@linux.dev>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit
+++ a/MAINTAINERS
@@ -10818,6 +10818,7 @@ F:	fs/smbfs_common/
 
 KERNEL UNIT TESTING FRAMEWORK (KUnit)
 M:	Brendan Higgins <brendanhiggins@google.com>
+M:	David Gow <davidgow@google.com>
 L:	linux-kselftest@vger.kernel.org
 L:	kunit-dev@googlegroups.com
 S:	Maintained
_

Patches currently in -mm which might be from brendan.higgins@linux.dev are


