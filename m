Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234D7C433B4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56EA613BE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhDFHtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhDFHtW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2021 03:49:22 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B68C06174A
        for <mm-commits@vger.kernel.org>; Tue,  6 Apr 2021 00:49:14 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FF05z4yYFz9sRf;
        Tue,  6 Apr 2021 17:49:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617695351;
        bh=FP8g8nIsIIk6sCZ4ijNfxoCazH2km6Q7QJh5x7ZFdmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p+fpCv0BVpEoToYNzKGlBYC3z2Pht1EoUQ5gwAFxhOZgBq4KNF0YbbrFIGSm9FECa
         Wx67ELFtqdZidRnx6Y1tPDUiB+++mW0AIKfGkJWWtyKb3HOvMi0S7dYQc4TRnSmXqG
         t/cGgw6PjvE54bavnyswTOjIIoBbKeyAtZtXHNZwlxa9ZPK538lqT5jWR2px5hP0aa
         WDjrtSylAKCRlKZpZcVjLx7q+BcDu6//CQ2ANa2D01DfhBD7dWIFXSddShU6kOy0WT
         GARgMsKvE3Jurc+6NGUJUsJNM6LiujxXHT5vjjjp0O9xaWfkdRr1EtWb4SeZEjstuM
         828pO+5LKUzuw==
Date:   Tue, 6 Apr 2021 17:49:10 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com
Subject: Re: + mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch added to
 -mm tree
Message-ID: <20210406174910.152c1eeb@canb.auug.org.au>
In-Reply-To: <20210406055453.MLuTCcBH_%akpm@linux-foundation.org>
References: <20210406055453.MLuTCcBH_%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PTWln8AhkVDtSN7w_dhDp2T";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/PTWln8AhkVDtSN7w_dhDp2T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 05 Apr 2021 22:54:53 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-vmalloc-remove-unmap_kernel_range-fix-fix
> has been added to the -mm tree.  Its filename is
>      mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/PTWln8AhkVDtSN7w_dhDp2T
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBsEnYACgkQAVBC80lX
0GyTtQf/VzgFgIlfzSVh6BIRjy2aFcmFx6qR+9l4c/crqhLVvXY7UqixnHk3AgLK
4FI18AFhu6P2PAZHMxOV3sZf0YW3iDhKOwx+RNQFWDGBOTBybyMbXNl5lkPCncgz
eymqBw7VAe9gaH1AxLf7tLFoSs/kVCg0vbH8Ldnzw+55eerW9ZCsZGHFP7eQKc9Z
yoEm3gAf3iWDKH/tGO08nVhLFWK2MTkuTDIRTSlpe58x8fi3AhG40p0VYDk1XNp4
8nqSOvb+sFlSEs/DYbxMtehPQ5UZ6sM8CJtAwRmjY7JiI4sXAs8+qcbu/DhgzRJP
gZ6LEVhb2Y1CPwUEKgXqZT5rWYUjWw==
=rOId
-----END PGP SIGNATURE-----

--Sig_/PTWln8AhkVDtSN7w_dhDp2T--
