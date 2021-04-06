Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988ACC433B4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40947613BE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhDFHr0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:47:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46855 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhDFHrZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 03:47:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FF03m1hstz9sRf;
        Tue,  6 Apr 2021 17:47:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617695236;
        bh=ADjmx9yUuhOpbFV7Er0RNSgWcmhjt05CLH0nqaXcMds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AhSG9xhXWbvsodKtIbyqHpqTziYBEPco2GXlvPGhVehD7jL0pe+9dXRtZ5Fn9La1Y
         DRhe4tCAWt8vRIFVCdLyZlbw929nkASk2zjiz7+P+4fJj0JqKJ55Z4MGt/nYQnRz8q
         JouFMUr7fflaUXtcUKo04kOj8spEK/TwOiAzDikMDGvYhPxJlsE4JGFyngIDHo7JlZ
         4t/XoAhkfg0NefEf48EbrdJkMxYSQzz/gaIkVGAD11m4Y0X85fd9pQuZcMvy4aJXRa
         KdYaGNCuOHgY8Y9UaWRlv3n6wEYEeBEpMXfKqirxSGrfuw99Db2A7xkYST8ScUYqKc
         AATrRKAkWP0Fg==
Date:   Tue, 6 Apr 2021 17:47:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com
Subject: Re: + mm-vmalloc-remove-unmap_kernel_range-fix.patch added to -mm
 tree
Message-ID: <20210406174715.2fae4cbb@canb.auug.org.au>
In-Reply-To: <20210402001333.Io1WjLZV7%akpm@linux-foundation.org>
References: <20210402001333.Io1WjLZV7%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JySg9IlVH3Gix_gUJUfy9wn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/JySg9IlVH3Gix_gUJUfy9wn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 01 Apr 2021 17:13:33 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-vmalloc-remove-unmap_kernel_range-fix
> has been added to the -mm tree.  Its filename is
>      mm-vmalloc-remove-unmap_kernel_range-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/JySg9IlVH3Gix_gUJUfy9wn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBsEgMACgkQAVBC80lX
0GysGwgAoOQyMSN83nOlekx68AJ1wlPw633Cb8V7d02eoluMej5A97ZBR9e5J7dn
ELN1eYic0gDTQHawyyzqZxDViptk0AZMXq8KJ/juGOOybV1d9NR6kXTa03g5KjtQ
gSn1UqSG0ftecZ1Iq9eYYAfvn5x9S6jpx/rE9JuzF+d/ikyeafn+E2IuRZmXE7M3
YWRIsEPccbS6f1dsnmVgTgqoIN+xeKBIia8fr4WrLDmEObKMQBsBK6VOPoleQ3SA
yXeTbaJpWNHV3ES0mcyl7ijgc13ytsTDBZn44AiaurwFdeSRL4KjFKuYBjcI9n2h
1fd1v5GBnWwkGsmvCv8ZxYgNWmeCsg==
=HJvU
-----END PGP SIGNATURE-----

--Sig_/JySg9IlVH3Gix_gUJUfy9wn--
