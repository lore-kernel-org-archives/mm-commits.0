Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542D3C19F2C
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239735AbiG3BJg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F0982F8C
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39E0CB82922
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2775C433C1;
        Sat, 30 Jul 2022 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143324;
        bh=sU0SEtZ10rGapAWO6S6F6SiT0bnROJCweCN50d/30TQ=;
        h=Date:To:From:Subject:From;
        b=bRgUHEwe81/e9f54py/xtKKM+UcSwPN545FyaUVjJLOD25hgW7vx1G2JVNan/Mm9I
         AvI9OTz9mNcCiKyv2Aj4VrAssZ42WqR2lhGCKnC0aqJMYP+VF/q1Frk4Z2oiPKNPhN
         D1BkIQswmpM+B1PCZ2H763VE+ybWgzhQEgTuyCCg=
Date:   Fri, 29 Jul 2022 18:08:43 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-add-soft-dirty-into-run_vmtestssh.patch removed from -mm tree
Message-Id: <20220730010843.E2775C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: add soft-dirty into run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-add-soft-dirty-into-run_vmtestssh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests: add soft-dirty into run_vmtests.sh
Date: Mon, 25 Jul 2022 10:20:48 -0400

Link: https://lkml.kernel.org/r/20220725142048.30450-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-add-soft-dirty-into-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -190,4 +190,6 @@ then
 	run_test ./protection_keys_64
 fi
 
+run_test ./soft-dirty
+
 exit $exitcode
_

Patches currently in -mm which might be from peterx@redhat.com are


