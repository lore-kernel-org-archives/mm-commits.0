Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6222D18EB5
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rpdi0zM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA47C433F1;
	Fri, 12 Jan 2024 23:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101690;
	bh=y5QCdCY9Mepyxqiw99RXtqk7Txp2yA4EU2Ga4NbisFA=;
	h=Date:To:From:Subject:From;
	b=Rpdi0zM7vSxWlnVs9qykgY019zjFHt7GiUTVX++K0KkreXwHC47HEEliO3BJQ3t3M
	 Y7EPgWUqtqbrIfV8znicWKNAppbZ6PJ0wHI+miVkmuo5txD66V/QfQ6z4qEBGk2z2x
	 32WOA94lmMZSJfwF8rPR3B39IOAJgDOcw8X98bPA=
Date: Fri, 12 Jan 2024 15:21:30 -0800
To: mm-commits@vger.kernel.org,xuyang2018.jy@fujitsu.com,wanlong.gao@gmail.com,vapier@gentoo.org,liwang@redhat.com,jstancek@redhat.com,aleksei.kodanev@bell-sw.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-ltp-maintainers.patch removed from -mm tree
Message-Id: <20240112232130.9BA47C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update LTP maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-update-ltp-maintainers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -12627,12 +12627,11 @@ F:	Documentation/devicetree/bindings/i2c
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


