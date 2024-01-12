Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD0E18EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJ2FSR10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775B8C433C7;
	Fri, 12 Jan 2024 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101703;
	bh=Y5PLE02k9VbqfG9clJ53Ka77mxpM68chE9gkw29B9rM=;
	h=Date:To:From:Subject:From;
	b=NJ2FSR10p0ocbFLqoq0iNzy7sxRC/y2xj5rP57BGjjQUId1ck+yW1+PZzafGKUZTd
	 wevcKc6fjwc6mnS8yWUATOaUVz7/lZwyf0RpMuJ92epB12o6ip0BQwxiWzUaW91IQJ
	 eH1aiRId8bYr9Ig4z8pLsfnj09ZjcPrLnIsorlo8=
Date: Fri, 12 Jan 2024 15:21:42 -0800
To: mm-commits@vger.kernel.org,tanzirh@google.com,ndesaulniers@google.com,justinstitt@google.com,tanzhasanwork@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-switch-email-for-tanzir-hasan.patch removed from -mm tree
Message-Id: <20240112232143.775B8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: switch email for Tanzir Hasan
has been removed from the -mm tree.  Its filename was
     mailmap-switch-email-for-tanzir-hasan.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


