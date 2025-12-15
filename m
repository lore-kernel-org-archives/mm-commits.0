Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E6D2DA76A
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765820939; cv=none; b=HKCjOuOwQKsS/+AAPcEaV4yPB8+z6OXtMErIx+RJvlPtT6zg1lFkEHotsASDC1iu3SOmA46lY0QY1BOa0ScMVD5yx/zCISqI0hDUVk+NkmmFex6NkssnGvbV6+xPY1oxLGt4D/sWT3/dju8IMd/rJx8HXl9JuqXrdrhiF5cZFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765820939; c=relaxed/simple;
	bh=U56EYdnnMDGeJGKKeo+MzRS4HpYlBJpgZlCI+T+0kP8=;
	h=Date:To:From:Subject:Message-Id; b=uYQPKlWQPfDqQxAFUtGmBvxthGR27oOrGRr69jueCyjYJovz3R+t9ueqPYZs+AfoV6Q1u05P9hRK9snJMIZCpeCPazEKXbYEGbXPBu3mq6FuWhzZNImNQ1JmLtv1yGAtwP3VXmJZ0SwNQOZT58ekhybZixLCCa4wHVWxECgaI6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jPWM0oY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jPWM0oY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288FBC4CEF5;
	Mon, 15 Dec 2025 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765820939;
	bh=U56EYdnnMDGeJGKKeo+MzRS4HpYlBJpgZlCI+T+0kP8=;
	h=Date:To:From:Subject:From;
	b=jPWM0oY5+iXRKElZJ/5mBW95bzv9x/YvYjORao56BvSRpd3ITFdZ0OFMnSZ7rLV6/
	 JKsE8ZdrTlEhjLa4YQHFAxEmTE+AFpe+3RhMhIhKzwtBRNRDNk7YakFoVMtJ+uRcaP
	 sc5lMsjnKhzpThyn9pP0G7uThVzkVz+yofFLgsuw=
Date: Mon, 15 Dec 2025 09:48:58 -0800
To: mm-commits@vger.kernel.org,hverkuil@kernel.org,bartosz.golaszewski@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-one-straggling-entry-for-bartosz-golaszewski.patch added to mm-hotfixes-unstable branch
Message-Id: <20251215174859.288FBC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update one straggling entry for Bartosz Golaszewski
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-one-straggling-entry-for-bartosz-golaszewski.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-one-straggling-entry-for-bartosz-golaszewski.patch

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
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: MAINTAINERS: update one straggling entry for Bartosz Golaszewski
Date: Thu, 4 Dec 2025 11:45:31 +0100

The entry for the Qualcomm bluetooth driver only now got sent upstream and
still has my old address.  Update it to use the kernel.org one.

Link: https://lkml.kernel.org/r/20251204104531.22045-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-one-straggling-entry-for-bartosz-golaszewski
+++ a/MAINTAINERS
@@ -21347,7 +21347,7 @@ F:	Documentation/devicetree/bindings/net
 F:	drivers/net/wwan/qcom_bam_dmux.c
 
 QUALCOMM BLUETOOTH DRIVER
-M:	Bartosz Golaszewski <brgl@bgdev.pl>
+M:	Bartosz Golaszewski <brgl@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/bluetooth/btqca.[ch]
_

Patches currently in -mm which might be from bartosz.golaszewski@oss.qualcomm.com are

maintainers-update-one-straggling-entry-for-bartosz-golaszewski.patch

