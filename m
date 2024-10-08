Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A921FA254
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728410160; cv=none; b=b1lK2zyPszKhtqsnjQRKlX+qnFiFqyDpdBCLkkc+ZVm8WEURo4hk6nsDzhgCVhk6k68z09G9+VzKTzW19rkGdvUjjzB700kv7zG8yiFpem27YdHdz6PqYfW2EMpBSI1YOkXey9crbiY1NVFlRB0JyrdUDqGLrubGDGEGbxjTTVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728410160; c=relaxed/simple;
	bh=s93WvzZao9Pag2QndP0jzxJtocme/f53T+a5BWDMlN0=;
	h=Date:To:From:Subject:Message-Id; b=SUw/2UGavl2Gq4tC/t+hK1oeRaXLxsL2E+uBZj6A8JBKviV+6C8Hg0rd9W0niRTYzjSHzBRyAexcRdjAZfd3S1n2eILscJe7TcYssMs6wc7xfBv/p+n+rqNbEro+M5MWFmNnXdFFK8ia386tH6txae/VkptaIj5WowrASnSGtok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LbL00Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LbL00Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDA4C4CEC7;
	Tue,  8 Oct 2024 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728410159;
	bh=s93WvzZao9Pag2QndP0jzxJtocme/f53T+a5BWDMlN0=;
	h=Date:To:From:Subject:From;
	b=0LbL00Nz0Yo5Mzikto2IirUYYT1Y5CKh8qOrru6pzY/EcRsMCtnq8qkUD4X4FuFYA
	 eaZl2W6okh9dqzfyMU2njhcd7N3ohVnr19KBu917nBPkwzlCKWXoUVWILNXOmWhWay
	 tt99bfAb98W8m4GuV6XK9EIZY4tuqXpwTStWwwJw=
Date: Tue, 08 Oct 2024 10:55:58 -0700
To: mm-commits@vger.kernel.org,srinivas.kandagatla@linaro.org,alexey.klimov@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-alexey-klimovs-email-address.patch added to mm-unstable branch
Message-Id: <20241008175559.7BDA4C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update Alexey Klimov's email address
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-mailmap-update-alexey-klimovs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-alexey-klimovs-email-address.patch

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
From: Alexey Klimov <alexey.klimov@linaro.org>
Subject: MAINTAINERS: mailmap: update Alexey Klimov's email address
Date: Tue, 8 Oct 2024 14:23:53 +0100

My new address is alexey.klimov@linaro.org

Link: https://lkml.kernel.org/r/20241008132353.68767-1-alexey.klimov@linaro.org
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-alexey-klimovs-email-address
+++ a/.mailmap
@@ -37,6 +37,7 @@ Alexei Avshalom Lazar <quic_ailizaro@qui
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
 Alexei Starovoitov <ast@kernel.org> <ast@plumgrid.com>
+Alexey Klimov <alexey.klimov@linaro.org> <klimov.linux@gmail.com>
 Alexey Makhalov <alexey.amakhalov@broadcom.com> <amakhalov@vmware.com>
 Alex Elder <elder@kernel.org>
 Alex Elder <elder@kernel.org> <aelder@sgi.com>
--- a/MAINTAINERS~maintainers-mailmap-update-alexey-klimovs-email-address
+++ a/MAINTAINERS
@@ -7877,7 +7877,7 @@ F:	Documentation/gpu/automated_testing.r
 F:	drivers/gpu/drm/ci/
 
 DSBR100 USB FM RADIO DRIVER
-M:	Alexey Klimov <klimov.linux@gmail.com>
+M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
@@ -13605,7 +13605,7 @@ Q:	http://patchwork.linuxtv.org/project/
 F:	drivers/media/dvb-frontends/m88rs2000*
 
 MA901 MASTERKIT USB FM RADIO DRIVER
-M:	Alexey Klimov <klimov.linux@gmail.com>
+M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
@@ -15762,7 +15762,7 @@ F:	Documentation/hwmon/mp9941.rst
 F:	drivers/hwmon/pmbus/mp9941.c
 
 MR800 AVERMEDIA USB FM RADIO DRIVER
-M:	Alexey Klimov <klimov.linux@gmail.com>
+M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
_

Patches currently in -mm which might be from alexey.klimov@linaro.org are

maintainers-mailmap-update-alexey-klimovs-email-address.patch

