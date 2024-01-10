Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06323C2F
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Wc1LfTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADA2C433C7;
	Wed, 10 Jan 2024 05:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704865335;
	bh=aWFEYcrFwtjCFiB//Pn9d8o1w5/s0s6twf9sgUJ3Txw=;
	h=Date:To:From:Subject:From;
	b=0Wc1LfTs5My+cmoE8f/1clSdK8OT2mYNSaDKaOjd1khmxyBg8g3628a9T750KmkuF
	 nV75udOP84xJ4jFJXrR2+QgVNLXAdHjxXbdln39x95qoXRR/TtrcwMi6uT/PoLy3tb
	 rWUGeSYDeObIBLNxZ0b2HG9tkL9InrpKRaH48D8o=
Date: Tue, 09 Jan 2024 21:42:14 -0800
To: mm-commits@vger.kernel.org,tanzirh@google.com,ndesaulniers@google.com,justinstitt@google.com,tanzhasanwork@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-switch-email-for-tanzir-hasan.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110054215.5ADA2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: switch email for Tanzir Hasan
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-switch-email-for-tanzir-hasan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-switch-email-for-tanzir-hasan.patch

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
From: Tanzir Hasan <tanzhasanwork@gmail.com>
Subject: mailmap: switch email for Tanzir Hasan
Date: Fri, 05 Jan 2024 23:44:34 +0000

Access to the tanzirh@google.com email will be revoked upon the end of the
internship.

Link: https://lkml.kernel.org/r/20240105-newemail-v3-1-3dc8ae035b54@google.com
Signed-off-by: Tanzir Hasan <tanzirh@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-switch-email-for-tanzir-hasan
+++ a/.mailmap
@@ -584,6 +584,7 @@ Surabhi Vishnoi <quic_svishnoi@quicinc.c
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> <tamizhr@codeaurora.org>
 Taniya Das <quic_tdas@quicinc.com> <tdas@codeaurora.org>
+Tanzir Hasan <tanzhasanwork@gmail.com> <tanzirh@google.com>
 Tejun Heo <htejun@gmail.com>
 Tomeu Vizoso <tomeu@tomeuvizoso.net> <tomeu.vizoso@collabora.com>
 Thomas Graf <tgraf@suug.ch>
_

Patches currently in -mm which might be from tanzhasanwork@gmail.com are

mailmap-switch-email-for-tanzir-hasan.patch

