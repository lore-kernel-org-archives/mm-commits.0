Return-Path: <SRS0=wvGk=CD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE3AC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Aug 2020 23:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2CD2075F
	for <mm-commits@archiver.kernel.org>; Tue, 25 Aug 2020 23:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598399692;
	bh=6MVRCvEUmmOhPtDfMQCpaOMHqJ6LOWObqGnTAiYvDgA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Zttwc4ldKzTk7TlOwedd7Y84w0R45JuZ32EU29Hy1wnwPSNzHgP/sUKC2hChSVyOE
	 XayP/SQPwJ2ElHtEZyC6n293PLGS1H8zNEjynMc7h8rgezmkCf7BF4Dxk1/FM770MC
	 vzmHYZ2yXF9H86nv+tQj3KzjLhywXGdPLNJq4KvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHYXyw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 19:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgHYXyv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 19:54:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B0E920738;
        Tue, 25 Aug 2020 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598399691;
        bh=6MVRCvEUmmOhPtDfMQCpaOMHqJ6LOWObqGnTAiYvDgA=;
        h=Date:From:To:Subject:From;
        b=SL9f7LKhl1y/6qZlr31Y4I4KoQI+sNb8Ux9aPc57q2b1KPMr/agLMjWN/o69JcU34
         yVr78Il7JFswvBSUPF8gaHcM/AHIM1SiRk2KBhH3fd9lPWIDODXRdps6LZvW69HQON
         1wnPtaDtp6vMluzFMbr5ZdG1L5KwvwIv8APqlDwE=
Date:   Tue, 25 Aug 2020 16:54:50 -0700
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com
Subject:  + maintainers-add-llvm-maintainers.patch added to -mm
 tree
Message-ID: <20200825235450.BTCsRbsMW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add LLVM maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-llvm-maintainers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-llvm-maintainers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-llvm-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: MAINTAINERS: add LLVM maintainers

Nominate Nathan and myself to be point of contact for clang/LLVM related
support, after a poll at the LLVM BoF at Linux Plumbers Conf 2020.

While corporate sponsorship is beneficial, its important to not entrust
the keys to the nukes with any one entity.  Should Nathan and I find
ourselves at the same employer, I would gladly step down.

Link: https://lkml.kernel.org/r/20200825143540.2948637-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-llvm-maintainers
+++ a/MAINTAINERS
@@ -4241,6 +4241,8 @@ S:	Maintained
 F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
+M:	Nathan Chancellor <natechancellor@gmail.com>
+M:	Nick Desaulniers <ndesaulniers@google.com>
 L:	clang-built-linux@googlegroups.com
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
_

Patches currently in -mm which might be from ndesaulniers@google.com are

maintainers-add-llvm-maintainers.patch

