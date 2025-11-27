Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6CC1FBEA2
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282439; cv=none; b=mcagHfpgbVoLU8mo7VhJH67v030lLggXNSFu4jMcAe/1umOo0v/kk84KZn2lqREpdCbwQvzDVcykhLjnNRjZOX+vAz1XiDeL66XtRawrIHCM40eVQFD8f44BQfKtbcl6Kas3ucfeKHB8sPqrrXFgnj7zItaJ4Y5gLh6KzLO1U/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282439; c=relaxed/simple;
	bh=Jb8F0/SpD999ZMkF1fGhza1k9GAweCBKbyePYswxzKQ=;
	h=Date:To:From:Subject:Message-Id; b=ak21MMiqbC/oibtzhHqRTjRBa3ZyQ5Y22pO1kQeZLECjOjsx2BRjU5EglmEooSo6fjBHmmPRSe6K9LBpyJrcQa0qmseRZpmwEnhh4VEBrz24im2dz9EEZQ6lHJwLLWWKY7NVfvjqlchQcbVMljoQBkZzxS/tFw8z0fOWfjIC7Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ktqu6sy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ktqu6sy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E1FC4CEF8;
	Thu, 27 Nov 2025 22:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282439;
	bh=Jb8F0/SpD999ZMkF1fGhza1k9GAweCBKbyePYswxzKQ=;
	h=Date:To:From:Subject:From;
	b=ktqu6sy7eEbMOyOXMhZdlQzBzLjllFESVA/Os75Tn7HIvKUGc7SfCPJw4+8fQDYBN
	 JeIfqFuxbGmGKdU03HPcZBEcdRzhdUT1w+3gmh8Pi1JDKJZ3RJxJ6O6v3fdQrBphAx
	 DU2852m1zucWDZmrLavapGAbrJl17iTwUpzqknqo=
Date: Thu, 27 Nov 2025 14:27:18 -0800
To: mm-commits@vger.kernel.org,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-tpm-device-driver-update-the-w-tag.patch removed from -mm tree
Message-Id: <20251127222719.74E1FC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: TPM DEVICE DRIVER: update the W-tag
has been removed from the -mm tree.  Its filename was
     maintainers-tpm-device-driver-update-the-w-tag.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: MAINTAINERS: TPM DEVICE DRIVER: update the W-tag
Date: Tue, 25 Nov 2025 18:03:53 +0200

I migrated test suite to git.kernel.org so that all my kernel stuff is
consolidated to one single place:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/about/

Link: https://lkml.kernel.org/r/20251125160353.2300402-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-tpm-device-driver-update-the-w-tag
+++ a/MAINTAINERS
@@ -26047,7 +26047,7 @@ M:	Jarkko Sakkinen <jarkko@kernel.org>
 R:	Jason Gunthorpe <jgg@ziepe.ca>
 L:	linux-integrity@vger.kernel.org
 S:	Maintained
-W:	https://codeberg.org/jarkko/linux-tpmdd-test
+W:	https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/about/
 Q:	https://patchwork.kernel.org/project/linux-integrity/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
 F:	Documentation/devicetree/bindings/tpm/
_

Patches currently in -mm which might be from jarkko@kernel.org are


