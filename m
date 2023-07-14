Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B63EB64DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 16:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbjGNQVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 12:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjGNQVf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 12:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C0230DE
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 09:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D576A61D64
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 16:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8C4C433C7;
        Fri, 14 Jul 2023 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689351693;
        bh=XU5iTCRx6thnaQM+idzuvyD7zdNIS3AKTaiWCgn5t3c=;
        h=Date:To:From:Subject:From;
        b=J1NnMwFEKry5FVgT4nPIB/YP7geAOYJje8MzNiPDuif+o0ok7N8kUhgNsCmvDhddP
         Ypj5P44jt+N0cKyiyKzEWU0Zc4TpeojylW7vkF39LJqt3Mq3PFTnFivwcfYUzsdLPX
         vKQAFXMnI0xVZxnKqcBYju0nQmEuZXUcrRnqzgxQ=
Date:   Fri, 14 Jul 2023 09:21:32 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        revest@chromium.org, Liam.Howlett@oracle.com, jhubbard@nvidia.com,
        jglisse@redhat.com, david@redhat.com, broonie@kernel.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-give-scripts-execute-permission.patch added to mm-hotfixes-unstable branch
Message-Id: <20230714162133.2F8C4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: give scripts execute permission
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-give-scripts-execute-permission.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-give-scripts-execute-permission.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: give scripts execute permission
Date: Thu, 13 Jul 2023 14:54:33 +0100

When run under run_vmtests.sh, test scripts were failing to run with
"permission denied" due to the scripts not being executable.

It is also annoying not to be able to directly invoke run_vmtests.sh,
which is solved by giving also it the execute permission.

Link: https://lkml.kernel.org/r/20230713135440.3651409-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-give-scripts-execute-permission.patch

