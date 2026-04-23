Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF692E266C
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776953047; cv=none; b=Izg07Unsqw6yll6pbYZaMVUU29+noEEAIfsieJwYHSvfBbnaRkqaNT7wkSwIYKKGd4A2pjIvspNoJa4ncwyumfFUj4eQwgZzBmE+APd+ADSDZGeaz3uA6BpL+pVUOYHGlbPGuksmIGtC/NsVE7DQL1jMnbg2bDcDqKF960tvB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776953047; c=relaxed/simple;
	bh=bnx2qxwovOyFrlsc1hz9nO4ypfHcj7/BseACLwZ0YHk=;
	h=Date:To:From:Subject:Message-Id; b=rhWciWoXhwmIGnB7edexjB2j5BX3ZSxNLpnm3/raIak19vZPgvq9d0qjYHG7TiYzIMBocIX35PUuQ5E1smDsFhaBzCtemNmEnrt57eRP+crXJZrJoUWO7kJFo2XdbEDOuk8SwfHww+6lIOw8N6AGMFKXdI13cH7L6a3ANxcMb0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPu41TkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPu41TkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA23C2BCAF;
	Thu, 23 Apr 2026 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776953047;
	bh=bnx2qxwovOyFrlsc1hz9nO4ypfHcj7/BseACLwZ0YHk=;
	h=Date:To:From:Subject:From;
	b=NPu41TkCGP3YAAgeXLJuVy7YZ8s0wy0IVZ2B03fQmJzset3+wAiFI9zesNaqzBW7v
	 H1KOQsOpnmecuLN/A04Erwms1jbLv+f9kBg074YdgvzvJVgq++2Xo4sdqJTl44Zk1c
	 AC2mB3sqFZETyPiIsShZUuxVhb6dwJfQZRsPAqH8=
Date: Thu, 23 Apr 2026 07:04:06 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,pvorel@suse.cz,martink@posteo.de,liwang@redhat.com,kuba@kernel.org,chrubis@suse.cz,arnd@arndb.de,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-li-wangs-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423140407.4DA23C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Li Wang's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-li-wangs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-li-wangs-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: MAINTAINERS: update Li Wang's email address
Date: Thu, 23 Apr 2026 21:26:49 +0800

Update my email address as my work email account is no longer in use. 
Also update .mailmap.

Link: https://lore.kernel.org/20260423132649.31126-1-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Petr Vorel <pvorel@suse.cz>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    2 ++
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-li-wangs-email-address
+++ a/.mailmap
@@ -506,6 +506,8 @@ Linus Walleij <linusw@kernel.org> <linus
 Linus Walleij <linusw@kernel.org> <linus.walleij@linaro.org>
 Linus Walleij <linusw@kernel.org> <triad@df.lth.se>
 <linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
+Li Wang <li.wang@linux.dev> <liwang@redhat.com>
+Li Wang <li.wang@linux.dev> <wangli.ahau@gmail.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
--- a/MAINTAINERS~maintainers-update-li-wangs-email-address
+++ a/MAINTAINERS
@@ -15257,7 +15257,7 @@ M:	Andrea Cervesato <andrea.cervesato@su
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
-M:	Li Wang <liwang@redhat.com>
+M:	Li Wang <li.wang@linux.dev>
 M:	Yang Xu <xuyang2018.jy@fujitsu.com>
 M:	Xiao Yang <yangx.jy@fujitsu.com>
 L:	ltp@lists.linux.it (subscribers-only)
_

Patches currently in -mm which might be from li.wang@linux.dev are

maintainers-update-li-wangs-email-address.patch

