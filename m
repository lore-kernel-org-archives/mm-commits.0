Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C938C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 21 May 2022 15:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiEUP0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 May 2022 11:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355449AbiEUP02 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 May 2022 11:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAFE60ABA
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 08:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E8260D2C
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 15:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE85C385A5;
        Sat, 21 May 2022 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653146786;
        bh=OKXs2TTj1bkaPEuTt3t84Mz6tixsQplFUMyifVx/nA4=;
        h=Date:To:From:Subject:From;
        b=E/2aipq0k0jQ9+5d1C5uXsTYwmyG0hcOkhFLVYrYbyIyxOTw0cH5FS4TRhWa3tRJF
         47/t+ocxv7sf6Sx7s1TfDs0JOmkYxRO2rYa4VsVTDYzGG/w093UNqHJZZYXbYPOHg2
         oACx7KnCA+ItFY/wkmTBP9qUqiarhE+Y/FuN1sfc=
Date:   Sat, 21 May 2022 08:26:24 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        Julia.Lawall@inria.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-pkeys-fix-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20220521152625.CEE85C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/pkeys: fix typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-pkeys-fix-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-pkeys-fix-typo-in-comment.patch

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
From: Julia Lawall <Julia.Lawall@inria.fr>
Subject: selftests/vm/pkeys: fix typo in comment
Date: Sat, 21 May 2022 13:11:30 +0200

Spelling mistake (triple letters) in comment.  Detected with the help of
Coccinelle.

Link: https://lkml.kernel.org/r/20220521111145.81697-80-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/protection_keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-fix-typo-in-comment
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1523,7 +1523,7 @@ void test_implicit_mprotect_exec_only_me
 	/*
 	 * Reset the shadow, assuming that the above mprotect()
 	 * correctly changed PKRU, but to an unknown value since
-	 * the actual alllocated pkey is unknown.
+	 * the actual allocated pkey is unknown.
 	 */
 	shadow_pkey_reg = __read_pkey_reg();
 
_

Patches currently in -mm which might be from Julia.Lawall@inria.fr are

ksm-fix-typo-in-comment.patch
selftests-vm-pkeys-fix-typo-in-comment.patch

