Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF885C072A2
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjKOXa4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjKOXau (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C9CE6
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 15:30:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF26BC433C7;
        Wed, 15 Nov 2023 23:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091046;
        bh=pRN+3BlVBSn0S41bZXzdRx4OH7jvvWiaAiLJEq5jhp4=;
        h=Date:To:From:Subject:From;
        b=iMSR5sqFVS9bXJMSo28yC9ENSfRzJTOKSodwzXFO7hi32Tzzo3A196yDBMxQcHsd8
         Sut+kJKE/qO5XS6CsLwcDySet7Tc2XuAyxbNk/e99VJXwuSWEie8/9JmKTtUILBmDb
         hiHhdg14JWYyrQ1Gtw1IMO+R/CCefHkohfGJcAGk=
Date:   Wed, 15 Nov 2023 15:30:46 -0800
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        leitao@debian.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch removed from -mm tree
Message-Id: <20231115233046.BF26BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add hugetlb_fault_after_madv to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: add hugetlb_fault_after_madv to .gitignore
Date: Fri, 3 Nov 2023 10:34:00 -0700

commit 116d57303a05 ("selftests/mm: add a new test for madv and hugetlb")
added a new test case, but, it didn't add the binary name in
tools/testing/selftests/mm/.gitignore.

Add hugetlb_fault_after_madv to tools/testing/selftests/mm/.gitignore.

Link: https://lkml.kernel.org/r/20231103173400.1608403-2-leitao@debian.org
Fixes: 116d57303a05 ("selftests/mm: add a new test for madv and hugetlb")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/all/662df57e-47f1-4c15-9b84-f2f2d587fc5c@arm.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-hugetlb_fault_after_madv-to-gitignore
+++ a/tools/testing/selftests/mm/.gitignore
@@ -45,3 +45,4 @@ mdwe_test
 gup_longterm
 mkdirty
 va_high_addr_switch
+hugetlb_fault_after_madv
_

Patches currently in -mm which might be from leitao@debian.org are


