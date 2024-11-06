Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48B6130A54
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854784; cv=none; b=kErgGz/8bWUyfyky0TlNHNrLZ9/MxQK2G3jf2duzoJYTv4iXarVcVmY/Wzr7Iun4oqlozRpC9uQuR2M83Jtreqvm9hOjXYCv9B6SQ5HNIED2xVf+eTvSs1gyRNqSw91UeJ8NUS0hg2B8BRKgeQvS55Uwg6rtF+P1goKC5W2MFN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854784; c=relaxed/simple;
	bh=xAwrwWGqoQW/Ndk0pw8p5sYQRQWGu9zYEBNWExVLDKE=;
	h=Date:To:From:Subject:Message-Id; b=S4qJGVXOISi5LXTbtTGmPk6wSuZe/nzCc6XB/my94/HQniG6AOVMLKvluX+a9C8DpFJEdr9du17DDUp+DJdt/xmwY1JOLhxfiZI2gVGWclRE0ib4I7BM4kks5x4vu1bxRyH2lWZo4I+f2QpnGcvK890pO+NtexT6Y3+qyBqdBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSOAZRyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSOAZRyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79166C4CECF;
	Wed,  6 Nov 2024 00:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854784;
	bh=xAwrwWGqoQW/Ndk0pw8p5sYQRQWGu9zYEBNWExVLDKE=;
	h=Date:To:From:Subject:From;
	b=bSOAZRyhZ+GN6ZKjfuptGUse57eDvqm66D0TeXRFGqX4ONe6t5VcqWDaSGkZM7wUF
	 U0toNE1NKcn3gORg8a/DR/UQgQ49oWc2LPXt9P0/j1ugA7YwymP2YO1YNbEF9iVyo8
	 MQx1+2BHXaKa0O0gnvqc3MdmKwFEjJ77KWh//iaY=
Date: Tue, 05 Nov 2024 16:59:43 -0800
To: mm-commits@vger.kernel.org,srinivas.kandagatla@linaro.org,alexey.klimov@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-mailmap-update-alexey-klimovs-email-address.patch removed from -mm tree
Message-Id: <20241106005944.79166C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update Alexey Klimov's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-alexey-klimovs-email-address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -7855,7 +7855,7 @@ F:	Documentation/gpu/automated_testing.r
 F:	drivers/gpu/drm/ci/
 
 DSBR100 USB FM RADIO DRIVER
-M:	Alexey Klimov <klimov.linux@gmail.com>
+M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
@@ -13568,7 +13568,7 @@ Q:	http://patchwork.linuxtv.org/project/
 F:	drivers/media/dvb-frontends/m88rs2000*
 
 MA901 MASTERKIT USB FM RADIO DRIVER
-M:	Alexey Klimov <klimov.linux@gmail.com>
+M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
@@ -15704,7 +15704,7 @@ F:	Documentation/hwmon/mp9941.rst
 F:	drivers/hwmon/pmbus/mp9941.c
 
 MR800 AVERMEDIA USB FM RADIO DRIVER
-M:	Alexey Klimov <klimov.linux@gmail.com>
+M:	Alexey Klimov <alexey.klimov@linaro.org>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
_

Patches currently in -mm which might be from alexey.klimov@linaro.org are


