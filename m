Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE43173E
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yC4xA7N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7558C433C7;
	Fri,  5 Jan 2024 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704473655;
	bh=50GKHkWZ/ff0LwFYPv2uk4q+WvAF8mEHM1GFbe4w6Rc=;
	h=Date:To:From:Subject:From;
	b=yC4xA7N6arBrcepsEHlTsna+wG7vmtUNlhRVRSIfN7DmP4Fi81jM+pbCnroY+5pVX
	 2wuAQg9QiQQJBKT+6oHYIXISNDZoZaB+2Z4co7JeMc/QLgWG7IULa9+JoHywlShy+2
	 SWN3hLoWOdX56U7gCxuo0mCwmA6kjWNkRXca8VKw=
Date: Fri, 05 Jan 2024 08:54:15 -0800
To: mm-commits@vger.kernel.org,xuyang2018.jy@fujitsu.com,wanlong.gao@gmail.com,vapier@gentoo.org,liwang@redhat.com,jstancek@redhat.com,aleksei.kodanev@bell-sw.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-ltp-maintainers.patch added to mm-hotfixes-unstable branch
Message-Id: <20240105165415.D7558C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update LTP maintainers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-ltp-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-ltp-maintainers.patch

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
From: Petr Vorel <pvorel@suse.cz>
Subject: MAINTAINERS: update LTP maintainers
Date: Thu, 4 Jan 2024 16:49:53 +0100

There are more people with git push permissions, but we keep only people
who actually did review and merge patches last year.

Link: https://lkml.kernel.org/r/20240104154953.1193634-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Li Wang <liwang@redhat.com>
Cc: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/MAINTAINERS~maintainers-update-ltp-maintainers
+++ a/MAINTAINERS
@@ -12583,12 +12583,11 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/muxes/i2c-mux-ltc4306.c
 
 LTP (Linux Test Project)
-M:	Mike Frysinger <vapier@gentoo.org>
 M:	Cyril Hrubis <chrubis@suse.cz>
-M:	Wanlong Gao <wanlong.gao@gmail.com>
 M:	Jan Stancek <jstancek@redhat.com>
-M:	Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
-M:	Alexey Kodanev <alexey.kodanev@oracle.com>
+M:	Petr Vorel <pvorel@suse.cz>
+M:	Li Wang <liwang@redhat.com>
+M:	Yang Xu <xuyang2018.jy@fujitsu.com>
 L:	ltp@lists.linux.it (subscribers-only)
 S:	Maintained
 W:	http://linux-test-project.github.io/
_

Patches currently in -mm which might be from pvorel@suse.cz are

maintainers-update-ltp-maintainers.patch

