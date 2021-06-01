Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F35C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7BFD613D2
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhFAU0D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 16:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234813AbhFAU0B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 16:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A3C61263;
        Tue,  1 Jun 2021 20:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622579059;
        bh=Lt+3eeu+J52jiBLvCznYrSb1MQdDazCqsCayX/sn4Vk=;
        h=Date:From:To:Subject:From;
        b=sfY8sECw2ufhRrtOlQS5bdCVoVP1DERE2Ew43CEl2GpBs5OF96JODTOyGIXMceR4r
         oTjeHVw4By3Vm9w1C4sjA4S95bYYrB8wAqSM/LYR4IiU5dn7TWwf/39UmMhHTFDzHq
         l/CQSfJgujzvOGl0NhQj73CS5tBlCkjeiOsPnhtM=
Date:   Tue, 01 Jun 2021 13:24:19 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, dmatlack@google.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, shuah@kernel.org
Subject:  + proc-add-gitignore-for-proc-subset-pid-selftest.patch
 added to -mm tree
Message-ID: <20210601202419.GbjunD8Li%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add .gitignore for proc-subset-pid selftest
has been added to the -mm tree.  Its filename is
     proc-add-gitignore-for-proc-subset-pid-selftest.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-add-gitignore-for-proc-subset-pid-selftest.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-add-gitignore-for-proc-subset-pid-selftest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Matlack <dmatlack@google.com>
Subject: proc: add .gitignore for proc-subset-pid selftest

This new selftest needs an entry in the .gitignore file otherwise git
will try to track the binary.

Link: https://lkml.kernel.org/r/20210601164305.11776-1-dmatlack@google.com
Signed-off-by: David Matlack <dmatlack@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/proc/.gitignore~proc-add-gitignore-for-proc-subset-pid-selftest
+++ a/tools/testing/selftests/proc/.gitignore
@@ -10,6 +10,7 @@
 /proc-self-map-files-002
 /proc-self-syscall
 /proc-self-wchan
+/proc-subset-pid
 /proc-uptime-001
 /proc-uptime-002
 /read
_

Patches currently in -mm which might be from dmatlack@google.com are

proc-add-gitignore-for-proc-subset-pid-selftest.patch

